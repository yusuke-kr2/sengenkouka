import { application } from "./application"
import AchieveController from "./achieve_controller"
import TabsController from "./tabs_controller"
import ImagePreviewController from "./image_preview_controller"
import LoadingController from "./loading_controller"
import AutocompleteController from "./autocomplete_controller"
import CharCountController from "./char_count_controller"
import DropdownController from "./dropdown_controller"

application.register("achieve", AchieveController)
application.register("tabs", TabsController)
application.register("image-preview", ImagePreviewController)
application.register("loading", LoadingController)
application.register("autocomplete", AutocompleteController)
application.register("char-count", CharCountController)
application.register("dropdown", DropdownController)

