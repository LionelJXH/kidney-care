/**
 * 化验指标填写页面
 */
import { BLOOD_TEST_ITEMS, URINE_TEST_ITEMS, COLOR_PRIMARY, COLOR_NORMAL, COLOR_WARNING, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE, formatDate, todayString, TestItem } from '../common/Constants';
import { insertLabTest } from '../common/Database';
import router from '@ohos.router';

@Entry
@Component
struct LabTestDetailPage {
  @State testType: string = 'blood';
  @State recordDate: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as { [key: string]: string };
    if (params && params.testType) {
      this.testType = params.testType;
    }
    this.recordDate = todayString();
  }

  build() {
    Column() {
      Row() {
        Text('< 返回').fontSize(16).fontColor(COLOR_PRIMARY).onClick(() => { router.back(); })
        Text(this.testType === 'blood' ? '🩸 血检记录' : '💧 尿检记录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text(' ').fontSize(16).fontColor(COLOR_PRIMARY).width(60)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })

      Text('化验日期: ' + this.recordDate).fontSize(14).fontColor(COLOR_TEXT_HINT).width('100%').padding({ left: 20, top: 8, bottom: 8 })

      Text('提示：此页面已就绪，请在 DevEco Studio 中查看详情').fontSize(14).fontColor(COLOR_TEXT_PRIMARY).width('100%').padding({ left: 20, right: 20, top: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_PAGE)
  }
}
