import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "bootstrap"

require("jquery")
require("packs/button_disable_script")

Rails.start()
Turbolinks.start()
ActiveStorage.start()
