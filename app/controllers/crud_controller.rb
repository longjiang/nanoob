class CrudController < ApplicationController
  
  include Nanoob::GenericModel
  
  class_attribute :permitted_attrs
  
  before_action :entry, only: [:show, :new, :edit, :update, :destroy]
  
  def index
    entries
  end
  
  def show
    instance_variable_set(:"@#{object_name false}", instance_variable_get(:"@#{object_name false}").send(:decorate))
  end
  #
  # def new
  # end
  
  #   POST /entries
  #   POST /entries.json
  #
  # Create a new entry of this model from the passed params.
  #
  # To customize the response for certain formats, you may overwrite
  # this action and call super with a block that gets the format and
  # success parameters. Calling a format action (e.g. format.html)
  # in the given block will take precedence over the one defined here.
  #
  # Specify a :location option if you wish to do a custom redirect.
  def create(options = {}, &block)
    assign_attributes
    created = entry.save
    respond_to do |format|
      block.call(format, created) if block_given?
      if created
        format.html { redirect_on_success(options) }
        format.json { render :show, status: :created, location: show_path }
      else
        format.html { render :new }
        format.json { render json: entry.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # def edit
  # end
  
  #   PUT /entries/1
  #   PUT /entries/1.json
  #
  # Update an existing entry of this model from the passed params.
  #
  # To customize the response for certain formats, you may overwrite
  # this action and call super with a block that gets the format and
  # success parameters. Calling a format action (e.g. format.html)
  # in the given block will take precedence over the one defined here.
  #
  # Specify a :location option if you wish to do a custom redirect.
  def update(options = {}, &block)
    assign_attributes
    updated = entry.save
    respond_to do |format|
      block.call(format, updated) if block_given?
      if updated
        format.html { redirect_on_success(options) }
        format.json { render :show, status: :ok, location: show_path }
      else
        format.html { render :edit }
        format.json { render json: entry.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #   DELETE /entries/1
  #   DELETE /entries/1.json
  #
  # Destroy an existing entry of this model.
  #
  # To customize the response for certain formats, you may overwrite
  # this action and call super with a block that gets format and
  # success parameters. Calling a format action (e.g. format.html)
  # in the given block will take precedence over the one defined here.
  #
  # Specify a :location option if you wish to do a custom redirect.
  def destroy(options = {}, &block)
    destroyed = entry.destroy
    respond_to do |format|
      block.call(format, destroyed) if block_given?
      if destroyed
        format.html { redirect_on_success(options) }
        format.json { head :no_content }
      else
        format.html { redirect_on_failure(options) }
        format.json { render json: entry.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def entries
    get_entries || set_entries
  end
  
  def entry
    get_entry || set_entry
  end
  
  # Assigns the attributes from the params to the model entry.
  def assign_attributes
    entry.attributes = model_params
  end

  # The form params for this model.
  def model_params
    params.require(model_identifier).permit(permitted_attrs)
  end
  
  # form params have been submitted
  def has_model_params?
    params[model_identifier].present?
  end
  
  # Path of the index page to return to.
  def index_path
    polymorphic_path(path_args(model_class), returning: true)
  end

  # Path of the show page.
  def show_path
    path_args(entry)
  end
  
  # Perform a redirect after a successfull operation and set a flash notice.
  def redirect_on_success(options = {})
    location = options[:location] ||
               (entry.destroyed? ? index_path : show_path)
    flash[:notice] ||= flash_message(:success)
    redirect_to location
  end

  # Perform a redirect after a failed operation and set a flash alert.
  def redirect_on_failure(options = {})
    location = options[:location] ||
               request.env['HTTP_REFERER'].presence ||
               index_path
    flash[:alert] ||= error_messages.presence || flash_message(:failure)
    redirect_to location
  end
  
  # Get an I18n flash message.
  # Uses the key {controller_name}.{action_name}.flash.{state}
  # or crud.{action_name}.flash.{state} as fallback.
  def flash_message(state)
    scope = "#{action_name}.flash.#{state}"
    keys = [:"#{controller_name}.#{scope}_html",
            :"#{controller_name}.#{scope}",
            :"crud.#{scope}_html",
            :"crud.#{scope}"]
    I18n.t(keys.shift, model: full_entry_label, default: keys)
  end
  
  # A label for the current entry, including the model name.
  def full_entry_label
    "#{models_label(false)} <i>#{ERB::Util.h(entry)}</i>".html_safe
  end
  
  # Html safe error messages of the current entry.
  def error_messages
    escaped = entry.errors.full_messages.map { |m| ERB::Util.html_escape(m) }
    escaped.join('<br/>').html_safe
  end

end