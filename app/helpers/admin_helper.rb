module AdminHelper
  def sidebar_state
    if cookies[:sidebar_minimized] == "true"
      "w-16"
    else
      "w-64"
    end
  end

  def sidebar_min_icon_state
    if cookies[:sidebar_minimized] == "true"
      "w-6 h-6 hidden"
    else
      "w-6 h-6"
    end
  end

  def sidebar_max_icon_state
    if cookies[:sidebar_minimized] == "true"
      "w-6 h-6"
    else
      "w-6 h-6 hidden"
    end
  end

  def sidebar_text_state
    if cookies[:sidebar_minimized] == "true"
      "hidden"
    else
      ""
    end
  end

  def sidebar_menu_item(path, icon, text, data: {})
    tag.li do
      link_to(path, class: "block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700", data: data) do
        concat(tag.i(class: "fas #{icon}"))
        concat(tag.span(text, class: "ml-2 #{sidebar_text_state}", data: { sidebar_target: "text" }))
      end
    end
  end
end
