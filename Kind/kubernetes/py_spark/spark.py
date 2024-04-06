import pyspark # type: ignore
from pyspark.sql import SparkSession # type: ignore
import pandas as pd # type: ignore

# Read CSV using pandas
pd_df = pd.read_csv("test.csv")
print(pd_df)

# Initialize Spark session
spark = SparkSession.builder.appName("Dataframe").getOrCreate()

# Read CSV file into DataFrame
df = spark.read.csv("test.csv", header=True, inferSchema=True)

# Show schema
print("Schema:")
df.printSchema()

# # Show data types
# print("\nData Types:")
# for column_name, data_type in df.dtypes:
#     print(f"{column_name}: {data_type}")

# Show DataFrame
print("\nDataFrame Contents:")
df.show()

# Stop SparkSession
spark.stop()