from __future__ import print_function
import sys
import re
from operator import add
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("NetflixRatings").getOrCreate()

if __name__ == "__main__":
     if len(sys.argv) != 3:
         print("Usage: wordcount <file>", file=sys.stderr)
         exit(-1)
         
     counts = spark.read.text(sys.argv[1]).rdd.map(lambda r: r[0])
     counts = counts.flatMap(lambda x: re.split('\W+', x.lower())).map(lambda x: (x, 1)).reduceByKey(add)
     output = counts.collect()
     output = sorted(output, key = lambda x: x[1])
     output.saveAsTextFile(sys.argv[2])	
spark.stop()