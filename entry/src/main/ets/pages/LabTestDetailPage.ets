/**
 * 化验指标填写页面
 * 根据化验类型（血检/尿检）显示对应的指标列表
 * 数值型 → 输入框
 * 选择型（定性）→ 选择器
 */
import { BLOOD_TEST_ITEMS, URINE_TEST_ITEMS, COLORS, formatDate, TestItem } from '../common/Constants';
import { insertLabTest } from '../common/Database';
import { Card } from '../common/Card';
import router from '@ohos.router';

@Entry
@Component
struct LabTestDetailPage {
  @State testType: string = 'blood';
  @State items: TestItem[] = BLOOD_TEST_ITEMS;
  @State values: { [key: string]: string } = {};
  @State selectValues: { [key: string]: string } = {};
  @State saved: boolean = false;
  @State errorMsg: string = '';
  @State recordDate: string = '';

  aboutToAppear(): void {
    // 获取路由参数
    const params = router.getParams() as { [key: string]: string };
    if (params && params.testType) {
      this.testType = params.testType;
      this.items = this.testType === 'blood' ? BLOOD_TEST_ITEMS : URINE_TEST_ITEMS;

      // 初始化默认值
      this.items.forEach((item: TestItem) => {
        if (item.type === 'number') {
          this.values[item.key] = '';
        } else if (item.type === 'select' && item.options && item.options.length > 0) {
          this.selectValues[item.key] = '- (阴性)';
        }
      });
    }

    // 默认显示今天的日期
    const now = new Date();
    const y = now.getFullYear();
    const m = (now.getMonth() + 1).toString().padStart(2, '0');
    const d = now.getDate().toString().padStart(2, '0');
    this.recordDate = `${y}-${m}-${d}`;
  }

  async saveRecord(): Promise<void> {
    this.errorMsg = '';

    // 收集填写的项目（只保存有值的）
    const filledItems: TestRecordItem[] = [];

    for (const item of this.items) {
      if (item.type === 'number') {
        const val = this.values[item.key];
        if (val && val.trim() !== '') {
          filledItems.push({
            key: item.key,
            name: item.name,
            unit: item.unit,
            value: val.trim(),
            type: 'number'
          });
        }
      } else if (item.type === 'select') {
        const val = this.selectValues[item.key];
        if (val && val !== '') {
          filledItems.push({
            key: item.key,
            name: item.name,
            unit: item.unit,
            value: val,
            type: 'select'
          });
        }
      }
    }

    // 解析日期
    const dateParts = this.recordDate.split('-');
    const recordTimestamp = new Date(
      parseInt(dateParts[0]),
      parseInt(dateParts[1]) - 1,
      parseInt(dateParts[2])
    ).getTime();

    try {
      await insertLabTest({
        timestamp: recordTimestamp,
        testType: this.testType === 'blood' ? 'blood' : 'urine',
        items: filledItems
      });
      this.saved = true;
      setTimeout(() => {
        router.back();
      }, 1500);
    } catch (e) {
      this.errorMsg = '保存失败，请重试';
    }
  }

  // 日期变更
  onDateChange(dir: number): void {
    const parts = this.recordDate.split('-');
    const d = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
    d.setDate(d.getDate() + dir);
    const y = d.getFullYear();
    const m = (d.getMonth() + 1).toString().padStart(2, '0');
    const day = d.getDate().toString().padStart(2, '0');
    this.recordDate = `${y}-${m}-${day}`;
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('< 返回')
          .fontSize(16).fontColor(COLORS.primary)
          .onClick(() => { router.back(); })
        Text(this.testType === 'blood' ? '🩸 血检记录' : '💧 尿检记录')
          .fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(60)
      }
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .width('100%')

      Scroll() {
        Column() {
          // 日期选择
          Card() {
            Row() {
              Text('📅').fontSize(20)
              Text('化验日期').fontSize(15).fontColor(COLORS.textPrimary).margin({ left: 8 })
              Text('<').fontSize(20).fontColor(COLORS.primary)
                .margin({ left: 16 })
                .onClick(() => { this.onDateChange(-1); })
              Text(this.recordDate).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.primary)
                .margin({ left: 12, right: 12 })
              Text('>').fontSize(20).fontColor(COLORS.primary)
                .onClick(() => { this.onDateChange(1); })
            }
            .padding(14)
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .margin({ top: 12 })

          // 指标列表
          ForEach(this.items, (item: TestItem) => {
            Card() {
              Column() {
                // 指标名称 + 正常范围
                Row() {
                  Text(item.name).fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                  if (item.normalRange) {
                    Text(`正常: ${item.normalRange}`)
                      .fontSize(11).fontColor(COLORS.textHint)
                      .margin({ left: 8 })
                  }
                }
                .width('100%')

                // 输入控件
                if (item.type === 'number') {
                  // 数值输入
                    Row() {
                      TextInput({ placeholder: item.placeholder, text: this.values[item.key] })
                        .placeholderColor(COLORS.textHint)
                        .fontSize(18).fontWeight(FontWeight.Bold)
                        .height(44).layoutWeight(1)
                        .type(InputType.Number)
                        .onChange((v: string) => {
                          this.values = { ...this.values, [item.key]: v };
                        })
                      if (item.unit) {
                        Text(item.unit).fontSize(14).fontColor(COLORS.textSecondary).margin({ left: 8 })
                      }
                    }
                    .margin({ top: 8 })
                } else {
                  // 选择型（定性） - 使用 RadioGroup
                  Column() {
                    Row() {
                      ForEach(item.options ?? [], (opt: string) => {
                        Row() {
                          Radio({ value: opt, group: item.key })
                            .checked(this.selectValues[item.key] === opt)
                            .onChange(() => {
                              this.selectValues = { ...this.selectValues, [item.key]: opt };
                            })
                          Text(opt).fontSize(14).fontColor(COLORS.textPrimary).margin({ left: 4 })
                        }
                        .margin({ right: 8 })
                      }, (opt: string) => opt)
                    }
                    .margin({ top: 8 })
                  }
                }
              }
              .padding(16)
              .width('100%')
            }
            .width('100%')
            .margin({ top: 2 })
          }, (item: TestItem) => item.key)

          // 错误提示
          if (this.errorMsg !== '') {
            Text(this.errorMsg).fontSize(14).fontColor(COLORS.warning).margin({ top: 12 })
          }

          // 保存按钮
          Button() {
            Text(this.saved ? '✅ 已保存' : '保存化验记录')
              .fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
          }
          .width('100%').height(52)
          .backgroundColor(this.saved ? COLORS.normal : COLORS.primary)
          .borderRadius(26)
          .margin({ top: 24, bottom: 40 })
          .enabled(!this.saved)
          .onClick(() => { this.saveRecord(); })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 20 })
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

