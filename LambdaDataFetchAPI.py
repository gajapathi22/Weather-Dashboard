import json
import requests
from datetime import datetime
import boto3

def lambda_handler(event, context):
    # Open-Meteo API (no API key needed)
    base_url = "https://api.open-meteo.com/v1/forecast"
    params = {
        'latitude': 40.71,  # New York coordinates
        'longitude': -74.01,
        'hourly': 'temperature_2m,relativehumidity_2m,windspeed_10m'
    }
    
    try:
        # Fetch weather data
        response = requests.get(base_url, params=params)
        response.raise_for_status()  # Raise error if API fails
        weather_data = response.json()
        
        # Store in S3
        s3 = boto3.client('s3')
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        file_name = f"weather_data_{timestamp}.json"
        bucket_name = "weather-data-bucket-gk"  
        
        s3.put_object(
            Bucket=bucket_name,
            Key=f"weather_data/{file_name}",
            Body=json.dumps(weather_data)
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Weather data stored successfully!')
        }
    
    except requests.exceptions.RequestException as e:
        print(f"API request failed: {e}")
        raise
    except Exception as e:
        print(f"Error: {e}")
        raise