const slideTitles = [
  "Introduction to Machine Learning in Epidemiology with R",
  "What machine learning means in an epidemiological context",
  "From an epidemiological question to a prediction task",
  "Preparing data for machine learning",
  "Logistic regression as a baseline model",
  "Decision trees and random forests",
  "Training and evaluating models with mlr3",
  "Cross-validation and performance on unseen data",
  "Sensitivity, specificity, confusion matrices and ROC/AUC",
  "Variable importance and model interpretation",
  "Prediction versus explanation and causation",
  "Limitations, bias and data quality in epidemiological machine learning"
];

const slide = document.querySelector("#slide");
const status = document.querySelector("#slide-status");
const previous = document.querySelector(".nav-button--previous");
const next = document.querySelector(".nav-button--next");
const fullscreen = document.querySelector("#fullscreen");
let current = 0;
let touchStartX = null;

function showSlide(index) {
  current = (index + slideTitles.length) % slideTitles.length;
  const number = current + 1;
  slide.src = `slides/slide-${number}.png`;
  slide.alt = `Slide ${number}: ${slideTitles[current]}`;
  status.textContent = `Slide ${number} of ${slideTitles.length}`;
  window.location.hash = `slide-${number}`;
}

function slideFromHash() {
  const match = window.location.hash.match(/^#slide-(\d+)$/);
  if (!match) return 0;
  const number = Number(match[1]);
  return Number.isInteger(number) && number >= 1 && number <= slideTitles.length ? number - 1 : 0;
}

previous.addEventListener("click", () => showSlide(current - 1));
next.addEventListener("click", () => showSlide(current + 1));

document.addEventListener("keydown", (event) => {
  if (["ArrowRight", "PageDown", " "].includes(event.key)) {
    event.preventDefault();
    showSlide(current + 1);
  }
  if (["ArrowLeft", "PageUp"].includes(event.key)) {
    event.preventDefault();
    showSlide(current - 1);
  }
  if (event.key === "Home") showSlide(0);
  if (event.key === "End") showSlide(slideTitles.length - 1);
});

document.addEventListener("touchstart", (event) => {
  touchStartX = event.changedTouches[0].clientX;
}, { passive: true });

document.addEventListener("touchend", (event) => {
  if (touchStartX === null) return;
  const distance = event.changedTouches[0].clientX - touchStartX;
  if (Math.abs(distance) > 50) showSlide(current + (distance < 0 ? 1 : -1));
  touchStartX = null;
}, { passive: true });

fullscreen.addEventListener("click", async () => {
  if (document.fullscreenElement) {
    await document.exitFullscreen();
  } else {
    await document.documentElement.requestFullscreen();
  }
});

window.addEventListener("hashchange", () => showSlide(slideFromHash()));
showSlide(slideFromHash());
