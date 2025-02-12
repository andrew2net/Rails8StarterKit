import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "text", "minIcon", "maxIcon"];

  connect() {
    this.sidebarTarget.addEventListener("transitionend", this.handlesTransitionEnd.bind(this));
  }

  toggle() {
    this.sidebarTarget.classList.toggle("-translate-x-full");
  }

  toggleMinimize() {
    const isMinimized = this.sidebarTarget.classList.toggle("w-16");
    this.sidebarTarget.classList.toggle("w-64");
    if (this.sidebarTarget.classList.contains("w-16")) {
      this.textTargets.forEach(el => el.classList.add("hidden"));
    }
    this.setCookie("sidebar_minimized", isMinimized, 7);
  }

  handlesTransitionEnd(event) {
    if (event.propertyName === 'width') {
      this.minIconTarget.classList.toggle("hidden");
      this.maxIconTarget.classList.toggle("hidden");

      if (this.sidebarTarget.classList.contains("w-64")) {
        this.textTargets.forEach(el => el.classList.remove("hidden"));
      }
    }
  }

  setCookie(name, value, days) {
    let expires = "";
    if (days) {
      const date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
  }
}
