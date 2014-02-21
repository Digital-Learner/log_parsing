class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(params[:campaign])
    if @campaign.save
      flash[:notice] = 'Campaign created.'
      redirect_to @campaign
    else
      flash[:error] = 'Failed to create campaign'
      render :new
    end
  end

  def show
  	@campaign = Campaign.find(params[:id])
  end
end
