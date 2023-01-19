class_name BitFlag extends Object


static func is_bit_enabled(mask: int, index: int) -> bool:
	return mask & (1 << index) != 0


static func set_bit(mask: int, index: int, enabled: bool) -> int:
	if enabled:
		return mask | (1 << index)
	else:
		return mask & ~(1 << index)
