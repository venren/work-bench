import boto3
import requests
import os

def uploadRawDataTos3():
    url = "https://www.kaggle.com/api/v1/datasets/download/nitindatta/finance-data"
    file_name = "/tmp/finance-data.zip"
    bucket_name = "raw-s3-bucket" 
    s3_key = "finance-data/finance-data.zip" # Replace with your S3 bucket name

    try:
        response = requests.get(url, allow_redirects=True)
        response.raise_for_status()  # Raise an error for bad responses

        with open(file_name, 'wb') as file:
            file.write(response.content)
        print(f"downloaded file successfully {file_name}")

        s3 = boto3.client("s3")
        s3.upload_file(file_name, bucket_name, s3_key)
        print(f"uploaded {file_name} to s3://{bucket_name}/{s3_key}")

        os.remove(file_name)

    except requests.exceptions.RequestException as e:
        print(f"download error: {e}")   

uploadRawDataTos3()