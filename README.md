# flutter_highlight_text
Flutter文本指定文字或者指定分割符高亮

### 使用方法
```
class TextPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  String text =
      '可能说起 Flutter 绘制，大家第一反应就是用 `CustomPaint` 组件，自定义 `CustomPainter` 对象来画。Flutter 中所有可以看得到的组件，比如 Text、Image、Switch、Slider 等等，追其根源都是`画出来`的，但通过查看源码可以发现，Flutter 中绝大多数组件并不是使用 `CustomPaint` 组件来画的，其实 `CustomPaint` 组件是对框架底层绘制的一层封装。这个系列便是对 Flutter 绘制的探索，通过`测试`、`调试`及`源码分析`来给出一些在绘制时`被忽略`或`从未知晓`的东西，而有些要点如果被忽略，就很可能出现问题。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [getText()],
          )),
    );
  }

  SliverToBoxAdapter getText() {
    return SliverToBoxAdapter(
      child: HighLightText(
        style: TextStyle(fontSize: 14, color: Colors.black),
        highLightTextStyle:
            TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        text: text,
        highLightWords: ['Flutter', '可'],
        highLightType: HighLightType.keyWords,
        //以分隔符分割
        //splitString: '`',
        //highLightType: HighLightType.splitCharacter,
        wordClickAction: (word) {
          print("=====$word");
        },
      ),
    );
  }
}
```
````
