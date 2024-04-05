package main

import (
    "fmt"
    "sync"
)

// NewCrawler initializes a new crawler
func NewCrawler() *Crawler {
    return &Crawler{
        visited: make(map[string]bool),
    }
}

//
// Serial Crawler
//

func Serial(url string, fetcher Fetcher, visited map[string]bool) {
	if visited[url] {
		return
	}
	visited[url] = true
	urls, err := fetcher.Fetch(url)
	if err != nil {
		return
	}
	for _, u := range urls {
		Serial(u, fetcher, visited)
	}
	return
}

//
// Concurrent Crawler - High Speed, Parallel Processing, using Map (MapReduce)
//

type crawlerState struct {
    mu      sync.Mutex
	visited map[string]bool
}

// *crawlerState = value | &crawlerState = address
func ConcurrentMutex(url string, fetcher Fetcher, f *crawlerState) {
	f.mu.Lock() // Locks the mutex to prevent concurrent access to shared state
	already := f.visited[url] // Checks if the URL has already been visited
	f.visited[url] = true // Marks the current URL as visited
	f.mu.Unlock() // Unlocks the mutex to allow other goroutines to access shared state

	if already {
		return // If the URL was already visited, return without further processing
	}

	urls, err := fetcher.Fetch(url) // Fetches child URLs from the current URL
	if err != nil {
		return // If an error occurs during fetching, return without further processing
	}

	var done sync.WaitGroup // Initializes a WaitGroup for coordination of goroutines
	for _, u := range urls {
		done.Add(1) // Increments the WaitGroup counter for each goroutine spawned
		go func(u string) {
			defer done.Done() // Decrements the WaitGroup counter when the goroutine completes
			ConcurrentMutex(u, fetcher, f) // Recursively calls ConcurrentMutex for each child URL
		}(u) // Passes the URL as a parameter to the goroutine
	}
	done.Wait() // Waits for all spawned goroutines to complete before returning
	return // Returns after all child URLs have been processed
}

func main() {
    // Create a new crawler
    crawler := NewCrawler()

    // URLs to crawl concurrently
    urls := []string{
        "https://example.com",
        "https://example.com/page1",
        "https://example.com/page2",
        "https://example.com/page3",
    }

    // Wait group to wait for all goroutines to finish
    var wg sync.WaitGroup
    wg.Add(len(urls))

    // Start a goroutine for each URL
    for _, url := range urls {
        go func(u string) {
            defer wg.Done()
            // Call the Crawl method on the crawler
            crawler.Crawl(u)
        }(url)
    }

    // Wait for all goroutines to finish
    wg.Wait()
}