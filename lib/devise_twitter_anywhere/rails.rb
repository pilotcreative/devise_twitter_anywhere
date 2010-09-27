ActiveSupport.on_load(:action_view) { include DeviseTwitterAnywhere::Rails::ViewHelpers }
ActiveSupport.on_load(:action_controller) { include DeviseTwitterAnywhere::Rails::ControllerHelpers }
