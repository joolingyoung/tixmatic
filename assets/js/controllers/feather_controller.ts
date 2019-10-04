import { Controller } from "stimulus";
import * as feather from "feather-icons";

export default class extends Controller {
  connect() {
    feather.replace()
  }
}
