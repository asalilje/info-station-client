<template>
  <div class="wrapper">
    <div class="item image weather-image" :style="imageDisplay" />
    <div class="item data" :style="dataDisplay">
      <div v-if="weatherLoading" class="loader">
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
      </div>
      <div v-else class="weather-data">
        <div class="weather-section">
          <div class="weather current" :data-text="getTime(currentWeather)">
            {{ getTemperature(currentWeather) }}&deg;
            <img :src="getSymbol(currentWeather)" />
          </div>
        </div>
        <div class="weather-section">
          <div
            class="weather coming"
            v-for="weather in comingWeather"
            :key="weather.$.from"
            :data-text="getTime(weather)"
          >
            {{ getTemperature(weather) }}&deg;
            <img :src="getSymbol(weather)" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Weather',
  props: {
    showData: {
      type: Boolean,
      required: true
    },
    weatherLoading: {
      type: Boolean,
      required: true
    },
    weatherData: {
      type: Object,
      required: false
    }
  },
  methods: {
    getTemperature(weather) {
      return weather && `${weather.temperature[0].$.value}`;
    },
    getSymbol(weather) {
      return (
        weather &&
        `https://symbol.yr.no/grafikk/sym/b100/${weather.symbol[0].$.var}.png`
      );
    },
    getTime(weather) {
      return weather && weather.$.from.split('T')[1].substring(0, 5);
    }
  },
  computed: {
    imageDisplay() {
      return {
        opacity: this.showData ? 0 : 1
      };
    },
    dataDisplay() {
      return {
        opacity: this.showData ? 1 : 0,
        transform: this.showData ? 'scale(1)' : 'scale(0.3)'
      };
    },
    currentWeather() {
      return this.weatherData && this.weatherData.body[0];
    },
    comingWeather() {
      return this.weatherData && this.weatherData.body.slice(1);
    }
  }
};
</script>

<style scoped>
.weather-image {
  background-image: url('../assets/weather.svg');
}

.weather-data {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.weather-section {
  display: flex;
  justify-content: center;
  margin: 10px;
}

.weather {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 30px;
  border-top-left-radius: unset;
  padding: 25px;
  border: 6px solid black;
  background: linear-gradient(
    to top,
    rgba(0, 0, 0, 0.1),
    rgba(255, 255, 255, 0.3)
  );
  box-shadow: 3px 3px 15px rgba(0, 0, 0, 0.4);
}

.weather:before {
  position: absolute;
  top: 0;
  left: -6px;
  transform: translateY(-100%);
  display: block;
  content: attr(data-text);
  padding: 5px 40px;
  border-top-right-radius: 15px;
  border-top-left-radius: 15px;
  background-color: black;
  color: white;
  font-size: 25px;
  font-weight: 400;
  box-shadow: 3px 0px 15px rgba(0, 0, 0, 0.4);
}

.current {
  width: 280px;
  font-size: 80px;
  margin-bottom: 60px;
}

.coming {
  width: 200px;
  margin: 20px;
  font-size: 60px;
}
</style>
