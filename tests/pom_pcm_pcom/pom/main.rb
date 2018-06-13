class NavBar < Superbara::POM

  def initialize(selector = "nav#mainNav")
    @elem = find selector
  end

  def item(wat)
    @elem.find("span", text: wat)
  end

  def tarjoukset_ja_vinkit
    item("Tarjoukset ja vinkit")
  end
end


visit "vr.fi"

wait do
  has_text? "Katso aikataulut"
end

nb = NavBar.new
nb.item("Tarjoukset ja vinkit").click
nb.tarjoukset_ja_vinkit.click
