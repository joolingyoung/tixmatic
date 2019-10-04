import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["name"]
  nameTarget!: HTMLInputElement;

  connect() {
    console.log("Connect, Stimulus!", this.element);
  }
  disconnect() {
    console.log("Disconnect, Stimulus!", this.element);
  }
  greet() {
    const name = this.nameTarget.value
    console.log(`Hello, Stimulus! ${name}`, this.element);
  }
}
