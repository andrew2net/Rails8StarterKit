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
    this.loaderTarget.classList.add("hidden");
    this.contentTarget.classList.remove("hidden");
  }

  close(event) {
    event.preventDefault();
    this.element.classList.add("hidden");
    this.contentTarget.innerHTML = "";
  }

  submit(event) {
    event.preventDefault();
    this.showLoader(event);
    const form = event.target;
    const formData = new FormData(form);
    const url = form.action;

    fetch(url, {
      method: "POST",
      body: formData,
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.text();
    })
    .then(html => {
      this.hideLoader(event);
      if (html.includes('id="modal"')) {
        this.contentTarget.innerHTML = html;
        this.element.classList.remove("hidden");
      } else {
        this.close(event);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      this.hideLoader(event);
    });
  }
}
