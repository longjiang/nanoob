class BusinessesController < CrudController
  self.permitted_attrs = [:name, :product_line, :language]
end
