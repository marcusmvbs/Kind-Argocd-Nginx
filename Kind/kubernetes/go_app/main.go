package main

import (
	"log"
	"math/rand"
	"net/http"
	"time"
	// Fiber web framework, Prometheus Client library, Prometheus server metrics exporter
	"github.com/gofiber/fiber/v2"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)
// Define struct metrics, duration pointering to prometheus object, allowing dynamic allocation of the object during runtime
type metrics struct { 
	duration *prometheus.SummaryVec
}

func NewMetrics(reg prometheus.Registerer) *metrics {
	m := &metrics{
		duration: prometheus.NewSummaryVec(prometheus.SummaryOpts{
			Namespace:  "webserver",
			Name:       "duration_seconds",
			Help:       "Duration of the request.",
			Objectives: map[float64]float64{0.9: 0.01, 0.99: 0.001},
		}, []string{"path", "status"}), // Labels
	}
	reg.MustRegister(m.duration) // Ensures the metric was registered to be scraped
	return m // Returns the pointer value to allocate on metrics object 
}

// Device represents any physical or virtual entity that the application interacts with, such as IoT devices
type Device struct { 
	ID       int    `json:"id"`
	Mac      string `json:"mac"`
	Firmware string `json:"firmware"`
}

func main() {
	reg := prometheus.NewRegistry()
	m := NewMetrics(reg)

	pMux := http.NewServeMux() // Create HTTP server 8081
	promHandler := promhttp.HandlerFor(reg, promhttp.HandlerOpts{}) // Responsible for serving prom metrics collected by registry(reg)
	pMux.Handle("/metrics", promHandler)

	go func() { // Routine to listen port 8181
		log.Fatal(http.ListenAndServe(":8181", pMux))
	}()

	go simulateTraffic(m) // Routine to simulate traffic using metrics (m) as an argument

	app := fiber.New() // Create new instance of Fiber web framework

	app.Get("/api/devices", getDevices)

	log.Fatal(app.Listen(":81")) // Create fiber HTTP server 81
}

func getDevices(c *fiber.Ctx) error {
	sleep(1000)
	dvs := []Device{
		{1, "5F-33-CC-1F-43-82", "2.1.6"},
		{2, "EF-2B-C4-F5-D6-34", "2.1.6"},
	}

	return c.JSON(dvs)
}
// It records the duration of a fake request using the duration metric from the metrics object 'm'
func simulateTraffic(m *metrics) {
	for {
		now := time.Now()
		sleep(1000)
		m.duration.WithLabelValues("/fake", "200").Observe(time.Since(now).Seconds()) // (path, status)
	}
}
// Delay function (sleep + rand)
func sleep(ms int) {
	rand.Seed(time.Now().UnixNano())
	now := time.Now()
	n := rand.Intn(ms + now.Second())
	time.Sleep(time.Duration(n) * time.Millisecond)
}