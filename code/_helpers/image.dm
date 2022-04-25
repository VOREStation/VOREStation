/image/proc/add_overlay(x)
	overlays += x


/image/proc/cut_overlay(x)
	overlays -= x


/image/proc/cut_overlays(x)
	overlays.Cut()


/image/proc/copy_overlays(atom/other, cut_old)
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old || !overlays.len)
			overlays = cached_other.Copy()
		else
			overlays |= cached_other
	else if(cut_old)
		cut_overlays()
