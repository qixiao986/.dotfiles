return {
  s("ternary", {
    t("("), i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else"), t(")")
  }),
}, {
	parse("autotrig", "autotriggered, if enabled")
}
