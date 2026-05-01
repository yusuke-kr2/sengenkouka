import { application } from "./application"
import AchieveController from "./achieve_controller"
import TabsController from "./tabs_controller"
import ImagePreviewController from "./image_preview_controller"

application.register("achieve", AchieveController)
application.register("tabs", TabsController)
application.register("image-preview", ImagePreviewController)

