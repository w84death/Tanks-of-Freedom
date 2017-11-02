func reload_button(button, translation, label_node_name="Label"):
    if button:
        self.reload_label(button.get_node(label_node_name), translation)

func reload_label(label, translation):
    if label:
        label.set_text(tr(translation))