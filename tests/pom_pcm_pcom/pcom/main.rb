class NavBar < Superbara::PCOM
  def initialize(selector = "nav#mainNav")
    @elem = find selector
  end

  def item(wat)
    @elem.find("span", text: wat)
  end

  def tarjoukset_ja_vinkit
    item("Tarjoukset ja vinkit")
  end

  def self.tarjoukset_ja_vinkit
    # or just...
    # self.new.find("span", text: "Tarjoukset ja vinkit")
    e = find("nav#mainNav")
    e.find("span", text: "Tarjoukset ja vinkit")
  end
end


visit "vr.fi"

wait do
  has_text? "Katso aikataulut"
end

nb = NavBar.new
nb.tarjoukset_ja_vinkit.click
NavBar.tarjoukset_ja_vinkit.click
