<template>
  <div class="wrapper">
    <div class="item image tube-image" :style="imageDisplay" />
    <div class="item data" :style="dataDisplay">
      <div v-if="tubeLoading" class="loader">
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
      <div v-else class="tube-data">
        <div class="time-table" data-text="Norrut">
          <div
            v-for="item in northBound"
            :key="item.JourneyNumber"
            class="time-table-row"
          >
            <div>{{ item.Destination }}</div>
            <div>{{ item.DisplayTime }}</div>
          </div>
        </div>

        <div class="time-table" data-text="Söderut">
          <div
            v-for="item in southBound"
            :key="item.JourneyNumber"
            class="time-table-row"
          >
            <div>{{ item.Destination }}</div>
            <div>{{ item.DisplayTime }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Tube',
  props: {
    showData: {
      type: Boolean,
      required: true
    },
    tubeLoading: {
      type: Boolean,
      required: true
    },
    tubeData: {
      type: Object,
      required: false
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
    northBound() {
      return (
        this.tubeData &&
        this.tubeData.body.filter(x => x.JourneyDirection === 1).slice(0, 3)
      );
    },
    southBound() {
      return (
        this.tubeData &&
        this.tubeData.body.filter(x => x.JourneyDirection === 2).slice(0, 3)
      );
    }
  }
};
</script>

<style scoped>
.tube-image {
  background-image: url('../assets/tube.svg');
}

.tube-data {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  font-size: 60px;
  font-weight: 800;
}

.time-table {
  position: relative;
  display: flex;
  width: 80%;
  flex-direction: column;
  margin-bottom: 20px;
  border: 3px solid black;
  padding: 20px 30px;
  box-sizing: border-box;
  border-radius: 10px;
  border-top-left-radius: unset;
  background: linear-gradient(
    to top,
    rgba(0, 0, 0, 0.1),
    rgba(255, 255, 255, 0.3)
  );
  box-shadow: 3px 3px 15px rgba(0, 0, 0, 0.4);
}

.time-table:first-of-type {
  margin-bottom: 60px;
}

.time-table:before {
  position: absolute;
  content: attr(data-text);
  display: block;
  top: 0;
  background: black;
  color: white;
  transform: translateY(-100%);
  font-size: 25px;
  font-weight: 400;
  padding: 5px 40px;
  left: -3px;
  border-top-right-radius: 15px;
  border-top-left-radius: 15px;
  box-shadow: 3px 0px 15px rgba(0, 0, 0, 0.4);
}

.time-table-row {
  display: flex;
  justify-content: space-between;
}
</style>
