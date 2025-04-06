import express from 'express';
import cors from 'cors';
import axios from 'axios';
import AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';

const app = express();
const PORT = 5000;

// Load environment variables from secrets
const S3_BUCKET = process.env.S3_BUCKET || 'your-bucket-name'; // Set via Kubernetes secret

// Configure AWS SDK
const s3 = new AWS.S3({
  region: process.env.AWS_REGION || 'us-east-1',
});

app.use(cors({
  origin: 'http://af2555f89d3c040be811eaca2505a9c5-748aa0237bcd9fd0.elb.us-east-1.amazonaws.com',
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

app.get('/api/weather', async (req, res) => {
  try {
    const { latitude, longitude } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).json({ error: 'Latitude and longitude are required' });
    }

    const params = {
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      hourly: 'temperature_2m,weathercode',
      timezone: 'auto'
    };

    const response = await axios.get('https://api.open-meteo.com/v1/forecast', { params });
    const weatherData = response.data;

    // Upload to S3
    const fileName = `weather-${uuidv4()}.json`;
    const uploadParams = {
      Bucket: S3_BUCKET,
      Key: fileName,
      Body: JSON.stringify(weatherData),
      ContentType: 'application/json'
    };

    await s3.putObject(uploadParams).promise();

    const s3Url = `https://${S3_BUCKET}.s3.amazonaws.com/${fileName}`;

    res.status(200).json({
      message: 'Weather data fetched and uploaded to S3',
      s3Url: s3Url
    });

  } catch (error) {
    console.error('Weather API Error:', {
      message: error.message,
      stack: error.stack,
      response: error.response?.data
    });

    res.status(500).json({
      error: 'Failed to fetch weather data or upload to S3',
      details: error.message
    });
  }
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
