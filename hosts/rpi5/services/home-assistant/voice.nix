{ pkgs, config, ... }:
let
  customSentences = pkgs.writeText "voice.yaml" ''
    language: "en"
    intents:
      GetPersonLocation:
        data:
          - sentences:
              - "where is {person}"
              - "where's {person}"
              - "locate {person}"
              - "find {person}"
              - "is {person} [at] home"
              - "is {person} at work"
    lists:
      person:
        values:
          - in: "jamie"
            out: "jamie"
          - in: "kat"
            out: "kat"
  '';
in
{
  services.home-assistant.config = {
    intent_script.GetPersonLocation = {
      speech.text = ''
        {% set people = {
          'jamie': {'entity': 'person.jamie', 'geocoded': 'sensor.jamie_pixel_8a_geocoded_location'},
          'kat': {'entity': 'person.kat', 'geocoded': 'sensor.kat_pixel_8a_geocoded_location'}
        } %}
        {% set name = person | lower | trim %}
        {% if name in people %}
          {% set entity = people[name].entity %}
          {% set location = states(entity) %}
          {% if location == 'home' %}
            {{ name | capitalize }} is at home
          {% elif location == 'not_home' %}
            {% set geo = states(people[name].geocoded) %}
            {% if geo not in ['unknown', 'unavailable', 'none'] and geo | length > 0 %}
              {{ name | capitalize }} is near {{ geo }}
            {% else %}
              {{ name | capitalize }} is away
            {% endif %}
          {% elif location in ['unknown', 'unavailable'] %}
            I'm not sure where {{ name | capitalize }} is right now
          {% else %}
            {{ name | capitalize }} is at {{ location }}
          {% endif %}
        {% else %}
          I don't know anyone named {{ person }}
        {% endif %}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.home-assistant.configDir}/custom_sentences/en 0755 hass hass"
    "L+ ${config.services.home-assistant.configDir}/custom_sentences/en/voice.yaml - - - - ${customSentences}"
  ];
}
