good_sequences = [
  %w(visit_payment_form select_phone_number visit_payment_form scroll read_contact_information),
  %w(select_phone_number click_link click_link visit_payment_form visit_payment_form),
  %w(select_phone_number scroll click_link visit_payment_form visit_payment_form)
]

bad_sequences = [
  %w(random_stuff scroll random_stuff do_nothing_for_a_while),
  %w(scroll click_link random_stuff),
  %w(click_link click_link do_nothing_for_a_while)
]

