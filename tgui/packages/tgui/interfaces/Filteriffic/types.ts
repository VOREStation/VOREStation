type MasterFilter = {
  alpha: {
    defaults: {
      x: number;
      y: number;
      icon: string;
      render_source: string;
      flags: number;
    };
    flags: {
      MASK_INVERSE: number;
      MASK_SWAP: number;
    };
  };
  angular_blur: {
    defaults: {
      x: number;
      y: number;
      size: number;
    };
  };
  color: {
    defaults: {
      color: string;
      space: number;
    };
    enums: {
      FILTER_COLOR_RGB: number;
      FILTER_COLOR_HSV: number;
      FILTER_COLOR_HSL: number;
      FILTER_COLOR_HCY: number;
    };
  };
  displace: {
    defaults: {
      x: number;
      y: number;
      size: number;
      icon: string;
      render_source: '';
    };
  };
  drop_shadow: {
    defaults: {
      x: number;
      y: number;
      size: number;
      offset: number;
      color: string;
    };
  };
  blur: {
    defaults: {
      size: number;
    };
  };
  layer: {
    defaults: {
      x: number;
      y: number;
      icon: string;
      render_source: string;
      flags: number;
      color: string;
      transform: null | number[];
      blend_mode: number;
    };
    enums: {
      BLEND_DEFAULT: number;
      BLEND_OVERLAY: number;
      BLEND_ADD: number;
      BLEND_SUBTRACT: number;
      BLEND_MULTIPLY: number;
      BLEND_INSET_OVERLAY: number;
    };
  };
  motion_blur: {
    defaults: {
      x: number;
      y: number;
    };
  };
  outline: {
    defaults: {
      size: number;
      color: string;
      flags: number;
    };
    flags: {
      OUTLINE_SHARP: number;
      OUTLINE_SQUARE: number;
    };
  };
  radial_blur: {
    defaults: {
      x: number;
      y: number;
      size: number;
    };
  };
  rays: {
    defaults: {
      x: number;
      y: number;
      size: number;
      color: string;
      offset: number;
      density: number;
      threshold: number;
      factor: number;
      flags: number;
    };
    flags: {
      FILTER_OVERLAY: number;
      FILTER_UNDERLAY: number;
    };
  };
  ripple: {
    defaults: {
      x: number;
      y: number;
      size: number;
      repeat: number;
      radius: number;
      falloff: number;
      flags: number;
    };
    flags: {
      WAVE_BOUNDED: number;
    };
  };
  wave: {
    defaults: {
      x: number;
      y: number;
      size: number;
      offset: number;
      flags: number;
    };
    flags: {
      WAVE_SIDEWAYS: number;
      WAVE_BOUNDED: number;
    };
  };
};

export type ActiveFilters = {
  type: string;
  priority: number;
} & Partial<MasterFilter>;

export type FilterEntryProps = {
  readonly name: string;
  readonly value: any;
  readonly hasValue: boolean;
  readonly filterName: string;
  readonly filterType: string;
};

export type Data = {
  filter_info: MasterFilter;
  target_name: string;
  target_filter_data: Record<string, ActiveFilters>;
};
