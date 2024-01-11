{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Notify when Jamie leaves home/work";
        id = "notify_jamie_leave_home_work";
        trigger = [
          {
            platform = "zone";
            entity_id = "person.jamie";
            zone = "zone.home";
            event = "leave";
          }
          {
            platform = "zone";
            entity_id = "person.jamie";
            zone = "zone.jamie_work";
            event = "leave";
          }
        ];
        action = [
          {
            variables = {
              event = "{{ 'left' if trigger.event == 'leave' else 'arrived at' }}";
              person = "{{ trigger.to_state.attributes.friendly_name }}";
              zone = "{{ trigger.zone.attributes.friendly_name }}";
            };
          }
          {
            service = "notify.mobile_app_pixel_5";
            data = {
              message = "{{ person + ' ' + event + ' ' + zone }}";
            };
          }
        ];
      }
      {
        alias = "Notify when Kat leaves home/work";
        id = "notify_kat_leave_home_work";
        trigger = [
          {
            platform = "zone";
            entity_id = "person.kat";
            zone = "zone.home";
            event = "leave";
          }
          {
            platform = "zone";
            entity_id = "person.kat";
            zone = "zone.kat_work";
            event = "leave";
          }
        ];
        action = [
          {
            variables = {
              event = "{{ 'left' if trigger.event == 'leave' else 'arrived at' }}";
              person = "{{ trigger.to_state.attributes.friendly_name }}";
              zone = "{{ trigger.zone.attributes.friendly_name }}";
            };
          }
          {
            service = "notify.mobile_app_pixel_6";
            data = {
              message = "{{ person + ' ' + event + ' ' + zone }}";
            };
          }
        ];
      }
    ];
  };
}
