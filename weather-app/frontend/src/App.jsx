import { useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [weather, setWeather] = useState(null);
  const [location, setLocation] = useState('');

  const fetchWeather = async () => {
    if (!location.trim()) return; // Skip if empty

    try {
      // Step 1: Convert location name to coordinates
      const geoResponse = await axios.get(
        `https://geocoding-api.open-meteo.com/v1/search?name=${location}&count=1`
      );

      const { latitude, longitude } = geoResponse.data.results[0];

      // Step 2: Fetch weather using coordinates
      const weatherResponse = await fetch(
        `http://a90d830f176fb49a098922c476dbf3e4-1000367513.us-east-1.elb.amazonaws.com/api/weather?latitude=${latitude}&longitude=${longitude}`
      );
      const weatherData = await weatherResponse.json();
      setWeather(weatherData);

    } catch (error) {
      console.error('Error:', error);
      alert('Location not found or API error');
    }
  };

  return (
    <div className="app">
      <h1>Weather Dashboard</h1>
      <input
        type="text"
        placeholder="Enter city (e.g., London)"
        value={location}
        onChange={(e) => setLocation(e.target.value)}
      />
      <button onClick={fetchWeather}>Get Weather</button>

      {weather && (
        <div className="weather-data">
          <h2>Weather in {location}</h2>
          <pre>{JSON.stringify(weather, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;