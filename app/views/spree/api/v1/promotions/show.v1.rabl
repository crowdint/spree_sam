object @promotion
cache [I18n.locale, current_currency, root_object]
attributes *promotion_attributes

node do |rule|
  {
    promotion_rules: rule.promotion_rules.collect do |rule|
      associations = rule.type.constantize.reflect_on_all_associations.map { |assoc| assoc.name} - [:promotion]
      extra = associations.inject({}) do |final, association|
        name = association.to_s.eql?(association.to_s.pluralize) ? "#{association.to_s.singularize}_ids" : "#{association}_id"
        final[name] = rule.send(name)
        final
      end
      {
          id: rule.id,
          user_id: rule.user_id,
          type: rule.type,
          code: rule.code,
          preferences: rule.preferences
      }.merge(extra)
    end,
    promotion_actions: rule.promotion_actions.collect do |action|
      {
        id: action.id,
        position: action.position,
        type: action.type,
        deleted_at: action.deleted_at,
        calculator: {
          type: action.calculator.type,
          preferences: action.calculator.preferences
        }
      }
    end
  }
end