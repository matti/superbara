class NavBar < Superbara::PCM
  def self.item(wat)
    elem = find "nav#mainNav"
    elem.find("span", text: wat)
  end

  def self.tarjoukset_ja_vinkit
    item("Tarjoukset ja vinkit")
  end
end


visit "vr.fi"

wait do
  has_text? "Katso aikataulut"
end

NavBar.item("Tarjoukset ja vinkit").click
NavBar.tarjoukset_ja_vinkit.click
