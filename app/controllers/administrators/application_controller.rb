class Administrators::ApplicationController < ApplicationController
  before_action :authenticate_administrator!
  layout 'administrator'
end
