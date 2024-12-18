{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Notify when Jamie leaves home/work";
        id = "notify_jamie_leave_home_work";
        triggers = [
          {
            trigger = "zone";
            entity_id = "person.jamie";
            zone = "zone.home";
            event = "leave";
          }
          {
            trigger = "zone";
            entity_id = "person.jamie";
            zone = "zone.jamie_work";
            event = "leave";
          }
        ];
        actions = [
          {
            variables = {
              event = "{{ 'left' if trigger.event == 'leave' else 'arrived at' }}";
              person = "{{ trigger.to_state.attributes.friendly_name }}";
              zone = "{{ trigger.zone.attributes.friendly_name }}";
            };
          }
          {
            action = "notify.mobile_app_kat_s_pixel";
            data = {
              message = "{{ person + ' ' + event + ' ' + zone }}";
            };
          }
        ];
      }
      {
        alias = "Notify when Kat leaves home/work";
        id = "notify_kat_leave_home_work";
        triggers = [
          {
            trigger = "zone";
            entity_id = "person.kat";
            zone = "zone.home";
            event = "leave";
          }
          {
            trigger = "zone";
            entity_id = "person.kat";
            zone = "zone.kat_work";
            event = "leave";
          }
        ];
        actions = [
          {
            variables = {
              event = "{{ 'left' if trigger.event == 'leave' else 'arrived at' }}";
              person = "{{ trigger.to_state.attributes.friendly_name }}";
              zone = "{{ trigger.zone.attributes.friendly_name }}";
            };
          }
          {
            action = "notify.mobile_app_jamie_pixel_8a";
            data = {
              message = "{{ person + ' ' + event + ' ' + zone }}";
            };
          }
        ];
      }
    ];
  };
}
