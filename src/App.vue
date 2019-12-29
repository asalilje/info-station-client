<template>
  <div id="app">
    <div class="garbageCollection" v-show="showGarbageAlert">
      <button @click="closeGarbage" class="close" />
    </div>
    <div class="tubeArea" @click="toggleTube" :style="tubeAreaWidth">
      <Tube
        :showData="showTubeData"
        :tubeLoading="tubeLoading"
        :tubeData="tubeData"
      />
    </div>
    <div class="weatherArea" @click="toggleWeather" :style="weatherAreaWidth">
      <Weather
        :showData="showWeatherData"
        :weatherLoading="weatherLoading"
        :weatherData="weatherData"
      />
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Tube from './components/Tube.vue';
import Weather from './components/Weather.vue';
export default {
  name: 'App',
  data() {
    return {
      tubeIsOpen: false,
      weatherIsOpen: false,
      showTubeData: false,
      showWeatherData: false,
      tubeLoading: false,
      weatherLoading: false,
      tubeData: null,
      weatherData: null,
      tubeRequestCount: 0,
      tubeRequestInterval: null,
      garbageClosed: false,
      today: null
    };
  },
  mounted() {
    this.changeToday();
    setInterval(this.changeToday, 1000 * 10);
  },
  components: {
    Tube,
    Weather
  },
  methods: {
    changeToday() {
      this.today = new Date();
      if (!this.isGarbageDay()) this.garbageClosed = false;
    },
    closeGarbage() {
      this.garbageClosed = true;
    },
    toggleTube() {
      this.closeWeather();
      this.tubeIsOpen = !this.tubeIsOpen;
      this.showTubeData = this.tubeIsOpen;
      if (this.tubeIsOpen) {
        this.tubeLoading = true;
        if (!this.tubeRequestInterval) {
          this.getTubeData();
          this.tubeRequestInterval = setInterval(() => {
            if (this.tubeRequestCount < 5) {
              this.getTubeData();
              this.tubeRequestCount += 1;
            } else {
              this.closeTube();
              this.resetInterval();
            }
          }, 60000);
        }
      }
      if (!this.tubeIsOpen) {
        this.resetInterval();
      }
    },
    toggleWeather() {
      this.closeTube();
      this.resetInterval();
      this.weatherIsOpen = !this.weatherIsOpen;
      this.showWeatherData = this.weatherIsOpen;
      if (this.weatherIsOpen) {
        this.weatherLoading = true;
        this.getWeatherData();
      }
    },
    resetInterval() {
      this.tubeRequestCount = 0;
      clearInterval(this.tubeRequestInterval);
      this.tubeRequestInterval = null;
    },
    closeWeather() {
      this.weatherIsOpen = false;
      this.showWeatherData = false;
    },
    closeTube() {
      this.tubeIsOpen = false;
      this.showTubeData = false;
    },
    getTubeData() {
      axios
        .get('http://localhost:3000/tube')
        .then(response => (this.tubeData = response.data))
        .then(() => (this.tubeLoading = false));
    },
    getWeatherData() {
      axios
        .get('http://localhost:3000/weather')
        .then(response => (this.weatherData = response.data))
        .then(() => (this.weatherLoading = false));
    },
    isGarbageDay() {
      return this.today ? this.today.getDay() === 0 : false;
    }
  },
  computed: {
    tubeAreaWidth() {
      return {
        width: this.tubeIsOpen ? '90%' : this.weatherIsOpen ? '10%' : '50%'
      };
    },
    weatherAreaWidth() {
      return {
        width: this.tubeIsOpen ? '10%' : this.weatherIsOpen ? '90%' : '50%'
      };
    },
    showGarbageAlert() {
      if (this.garbageClosed) return false;
      return this.isGarbageDay();
    }
  }
};
</script>

<style>
html,
body {
  height: 100%;
  margin: 0;
}

#app {
  height: 100%;
  display: flex;
  font-family: 'Open Sans', sans-serif;
  cursor: none;
  overflow: hidden;
}

.garbageCollection {
  position: absolute;
  margin: auto;
  width: 300px;
  height: 300px;
  right: 0;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 1;
  border-radius: 12%;
  border: 4px solid white;
  background-color: darkgreen;
  background-image: url('./assets/trash.svg');
  background-size: 75%;
  background-repeat: no-repeat;
  background-position: center;
  animation: backgroundCycle 3s linear infinite;
}

.close {
  position: absolute;
  right: 15px;
  top: 15px;
  width: 32px;
  height: 32px;
  background-color: transparent;
  border: 0;
}

.close:before,
.close:after {
  top: 0;
  position: absolute;
  content: ' ';
  height: 33px;
  width: 4px;
  background-color: white;
}
.close:before {
  transform: rotate(45deg);
}
.close:after {
  transform: rotate(-45deg);
}

.tubeArea {
  height: 100%;
  display: flex;
  background-color: #de49e2;
  transition: width 1s ease;
}

.weatherArea {
  height: 100%;
  display: flex;
  background-color: #3ce6e6;
  transition: width 1s ease;
}

.wrapper {
  position: relative;
  width: 100%;
  height: 100%;
}

.item {
  position: absolute;
  display: flex;
  justify-content: center;
  align-items: center;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  margin: auto;
  transition: all 0.5s ease;
}

.image {
  background-position: center;
  background-size: 90%;
  background-repeat: no-repeat;
}

.data {
  transition: all 0.5s ease;
}

.loader {
  display: inline-block;
  position: relative;
  width: 64px;
  height: 64px;
}

.loader div {
  position: absolute;
  width: 13px;
  height: 13px;
  border-radius: 50%;
  background: #000;
  animation: loader 1.2s linear infinite;
}

.loader div:nth-child(1) {
  top: 6px;
  left: 6px;
  animation-delay: 0s;
}

.loader div:nth-child(2) {
  top: 6px;
  left: 26px;
  animation-delay: -0.4s;
}

.loader div:nth-child(3) {
  top: 6px;
  left: 45px;
  animation-delay: -0.8s;
}

.loader div:nth-child(4) {
  top: 26px;
  left: 6px;
  animation-delay: -0.4s;
}

.loader div:nth-child(5) {
  top: 26px;
  left: 26px;
  animation-delay: -0.8s;
}

.loader div:nth-child(6) {
  top: 26px;
  left: 45px;
  animation-delay: -1.2s;
}

.loader div:nth-child(7) {
  top: 45px;
  left: 6px;
  animation-delay: -0.8s;
}

.loader div:nth-child(8) {
  top: 45px;
  left: 26px;
  animation-delay: -1.2s;
}

.loader div:nth-child(9) {
  top: 45px;
  left: 45px;
  animation-delay: -1.6s;
}

@keyframes loader {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes backgroundCycle {
  0%,
  100% {
    background-color: green;
  }
  25% {
    background-color: blue;
  }
  50% {
    background-color: red;
  }
  75% {
    background-color: yellow;
  }
}
</style>
