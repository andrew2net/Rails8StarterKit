import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "text", "minIcon"];

  connect() {
    this.sidebarTarget.addEventListener("transitionend", this.handlesTransitionEnd.bind(this));
    this.loadSidebatState();
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
    localStorage.setItem("sidebarMinimized", isMinimized);
  }

  handlesTransitionEnd(event) {
    if (event.propertyName === 'width') {
      this.minIconTargets.forEach(el => el.classList.toggle("hidden"));

      if (this.sidebarTarget.classList.contains("w-64")) {
        this.textTargets.forEach(el => el.classList.remove("hidden"));
      }
    }
  }

  loadSidebatState() {
    const isMinimized = localStorage.getItem("sidebarMinimized") === "true";
    if (isMinimized) {
      this.sidebarTarget.classList.remove("transition-all", "duration-200", "ease-in-out");

      this.sidebarTarget.classList.add("w-16");
      this.sidebarTarget.classList.remove("w-64");
      this.textTargets.forEach(el => el.classList.add("hidden"));
      this.minIconTargets.forEach(el => el.classList.toggle("hidden"));

      void this.sidebarTarget.offsetWidth; // Trigger reflow
      this.sidebarTarget.classList.add("transition-all", "duration-200", "ease-in-out");
    }
  }
}
