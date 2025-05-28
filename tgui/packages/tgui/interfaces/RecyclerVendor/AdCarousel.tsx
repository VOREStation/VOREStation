import { Section } from 'tgui-core/components';

import { adverts } from './constants';
export const AdCarousel = () => {
  return (
    <div>
      <Section>
        <div className="recycler-carousel">
          <div className="recycler-carousel-track">
            {/* shitty adverts */}
            {adverts.concat(adverts).map((item, index) => (
              <div key={index} className="recycler-carousel-box">
                {item}
              </div>
            ))}
          </div>
        </div>
      </Section>
    </div>
  );
};
