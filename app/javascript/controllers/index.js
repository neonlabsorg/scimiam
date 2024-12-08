// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"

// https://www.stimulus-components.com/docs/stimulus-reveal-controller
import Reveal from 'stimulus-reveal-controller' 
application.register('reveal', Reveal) 

// https://github.com/excid3/tailwindcss-stimulus-components#tabs
import { Tabs } from "tailwindcss-stimulus-components"
application.register('tabs', Tabs)

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
