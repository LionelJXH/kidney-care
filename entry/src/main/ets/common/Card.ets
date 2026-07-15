/**
 * 通用卡片容器组件
 */
import { COLORS } from './Constants';

@Component
export struct Card {
  @BuilderParam content: () => void = this.emptyBuilder;

  @Builder emptyBuilder() {
  }

  build() {
    Column() {
      this.content();
    }
    .backgroundColor(COLORS.cardBg)
    .borderRadius(14);
  }
}
