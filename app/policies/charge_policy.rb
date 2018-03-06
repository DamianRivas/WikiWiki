class ChargePolicy < Struct.new(:user, :charges)
  def new?
    user.present? && user.standard?
  end
  
  def create?
    new?
  end
end