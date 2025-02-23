import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader", "content"];

  connect() {
    this.element.addEventListener("turbo:before-fetch-request", this.showLoader.bind(this));
    this.element.addEventListener("turbo:before-fetch-response", this.hideLoader.bind(this));
  }

  disconnect() {
    this.element.removeEventListener("turbo:before-fetch-request", this.showLoader.bind(this));
    this.element.removeEventListener("turbo:before-fetch-response", this.hideLoader.bind(this));
  }

  showLoader(event) {
    this.loaderTarget.classList.remove("hidden");
    this.element.classList.remove("hidden");
    this.contentTarget.classList.add("hidden");
  }

  hideLoader(event) {
    if (event.detail.fetchResponse.statusCode === 204) {
      this.close(event);
    } else {
      this.loaderTarget.classList.add("hidden");
      this.contentTarget.classList.remove("hidden");
    }
  }

  close(event) {
    event.preventDefault();
    this.element.classList.add("hidden");
    this.contentTarget.innerHTML = "";
  }
}
