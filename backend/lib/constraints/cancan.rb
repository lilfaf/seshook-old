module Constraint
  class CanCan
    def initialize(action, resource)
      @action = action
      @resource = resource
    end

    def matches?(request)
      false unless user = request.env['warden'].user
      ability = Ability.new(user)
      ability.can?(@action, @resource)
    end
  end
end
