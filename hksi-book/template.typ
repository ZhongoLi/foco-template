// ==========================================
// HKSI 学习笔记专用模板
// ==========================================

// 1. 字体配置
// ------------------------------------------

// 字体栈策略：优先使用开源高质量字体，回退到系统默认字体
// 衬线体 (用于正文)：思源宋体 -> Noto宋体 -> 中易宋体 -> 苹方-简
#let font-serif = ("Source Han Serif SC", "Noto Serif CJK SC", "SimSun", "Songti SC", "PingFang SC")
// 非衬线体 (用于标题/强调)：思源黑体 -> Noto黑体 -> 微软雅黑 -> 黑体 -> 苹方-简
#let font-sans = ("Source Han Sans SC", "Noto Sans CJK SC", "Microsoft YaHei", "SimHei", "Heiti SC", "PingFang SC")

// 2. 配色方案
// ------------------------------------------
#let color-main = rgb("#0056B3")       // 稳重的深蓝色 (用于标题/数字)
#let color-dark = rgb("#2C3E50")       // 深蓝灰色 (用于正文)
#let color-light-gray = rgb("#F0F4F8") // 极淡的蓝灰底色
#let color-highlight = rgb("#FFFACD")  // 柠檬黄高亮
#let color-text = rgb("#333333")       // 正文黑灰
#let color-gray-bar = rgb("#E0E0E0")   // 分隔线颜色
#let color-paper-bg = rgb("#F9F8F6")   // 教科书米白底色 (Warm Paper)

// 侧边栏专用色
#let color-note-blue = rgb("#E3F2FD")  // 极淡蓝
#let color-note-brown = rgb("#FFF3E0") // 淡橙/棕色底

// 楷体 (用于加粗强调)：楷体 -> 华文楷体 -> 楷体-简
#let font-kaiti = ("KaiTi", "STKaiti", "Kaiti SC", "SimKai")

// 3. 核心工具函数
// ------------------------------------------


// 1. 自动计数器
#let mark(content) = box(
  fill: color-highlight,
  inset: (x: 2pt, y: 0pt),
  radius: 2pt,
  outset: (y: 2pt),
  content,
)

// [2] 彩色重点词
#let term(content) = text(fill: color-main, weight: "bold", content)

// [3] 全宽通栏大标题 (章首)
#let header-banner(num, title-cn) = {
  block(
    width: 100%,
    fill: color-main,
    outset: (top: 2cm, left: 1.5cm, right: 1.5cm),
    inset: (y: 30pt),
    radius: (bottom: 20pt),
    clip: true,
    {
      // 装饰文字
      place(
        bottom + right,
        dx: 2cm,
        dy: 1.5cm,
        rotate(-10deg, text(
          fill: white.transparentize(94%),
          size: 140pt,
          weight: "black",
          "CHAPTER",
        )),
      )
      // 标题内容
      grid(
        columns: (auto, 1fr),
        gutter: 20pt,
        align: horizon,
        text(fill: white, size: 80pt, weight: "extrabold", num),
        text(fill: white, size: 32pt, weight: "bold", title-cn),
      )
    },
  )
  v(1cm)
}

// [4] 引入框
#let intro-box(title, body) = {
  block(width: 100%, stroke: none, spacing: 0pt, below: 0pt, [
    #block(
      fill: color-dark,
      width: 100%,
      inset: (x: 12pt, y: 8pt),
      radius: (top: 4pt),
      text(fill: white, weight: "bold", size: 11pt, font: font-sans, title),
    )
    #block(
      fill: color-light-gray,
      width: 100%,
      inset: 12pt,
      radius: (bottom: 4pt),
      body,
    )
  ])
  v(1cm)
}

// [5] 分隔条
#let separator(text-content) = {
  v(0.5em)
  block(
    fill: rgb("#E0E0E0"),
    width: 100%,
    inset: (x: 10pt, y: 4pt),
    radius: 2pt,
    text(fill: luma(100), weight: "bold", size: 9pt, font: font-sans, text-content),
  )
  v(0.5em)
}

// [6] 灰色信息块
#let info-box(content) = block(
  fill: color-light-gray,
  width: 100%,
  inset: 10pt,
  radius: 2pt,
  content,
)

// [7] 胶囊标签
#let badge(content) = box(
  fill: color-main.transparentize(90%),
  stroke: 0.5pt + color-main.transparentize(40%),
  inset: (x: 6pt, y: 1pt),
  radius: 4pt,
  outset: (y: 1pt),
  text(fill: color-main, size: 9pt, weight: "bold", font: font-sans, content),
)

// [8] 侧边栏笔记框
#let sidenote(title, content, style: "blue") = {
  if style == "sticky" {
    block(
      width: 100%,
      inset: 10pt,
      radius: 0pt,
      fill: rgb("#FFF9C4"),
      stroke: (bottom: 1pt + rgb("#FBC02D"), right: 1pt + rgb("#FBC02D")),
      breakable: false,
      [
        #text(fill: rgb("#F57F17"), weight: "bold", size: 9pt, font: font-sans)[📌 #title]
        #v(3pt)
        #text(size: 9pt, fill: rgb("#333333"), content)
      ],
    )
  } else if style == "gray" {
    block(
      width: 100%,
      inset: 8pt,
      radius: 2pt,
      stroke: (left: 2pt + rgb("#9E9E9E")),
      breakable: false,
      [
        #text(fill: rgb("#616161"), weight: "bold", size: 8pt, font: font-sans)[■ #title]
        #v(3pt)
        #text(size: 8pt, fill: rgb("#424242"), content)
      ],
    )
  } else {
    let styles = (
      blue: (bg: color-note-blue, bar: color-main, title: white),
      brown: (bg: color-note-brown, bar: rgb("#8D6E63"), title: white),
      red: (bg: rgb("#FFEBEE"), bar: rgb("#E53935"), title: white),
      green: (bg: rgb("#E8F5E9"), bar: rgb("#2E7D32"), title: white),
    )
    let current-style = styles.at(style, default: styles.blue)
    block(
      width: 100%,
      fill: current-style.bg,
      inset: 0pt,
      radius: 4pt,
      clip: true,
      breakable: false,
      [
        #block(
          width: 100%,
          fill: current-style.bar,
          inset: (x: 8pt, y: 4pt),
          below: 6pt,
          text(fill: current-style.title, size: 8pt, weight: "bold", font: font-sans, title),
        )
        #block(
          inset: (left: 8pt, right: 8pt, bottom: 8pt, top: 4pt),
          text(size: 8pt, fill: rgb("#555555"), content),
        )
      ],
    )
  }
  v(10pt)
}

// [9] 二级小标题
#let sub-section(num, title) = {
  v(0.5em)
  text(fill: color-main, size: 14pt, weight: "extrabold", font: font-sans, str(num))
  h(0.5em)
  text(fill: color-dark, size: 12pt, weight: "bold", font: font-sans, title)
  v(0.3em)
}

// [10] 内容分块 (微型 Grid)
#let segment(body, note: none) = {
  let content-col = [
    #set par(leading: 0.8em, justify: true)
    #set list(indent: 1em, body-indent: 0.5em)
    #body
  ]

  if note != none {
    grid(
      columns: (1fr, 5cm),
      gutter: 0.8cm,
      content-col, align(top, note),
    )
  } else {
    // 保持右侧留白
    grid(
      columns: (1fr, 5cm),
      gutter: 0.8cm,
      content-col, none,
    )
  }
  v(10pt)
}

// [11] 核心布局容器
#let topic-block(num, title, content) = {
  grid(
    columns: (auto, 1fr),
    gutter: 10pt,
    align: horizon,
    box(fill: color-main, width: 24pt, height: 24pt, radius: 2pt, align(center + horizon, text(
      fill: white,
      weight: "bold",
      size: 14pt,
      font: font-sans,
      str(num),
    ))),
    text(size: 16pt, weight: "bold", fill: color-dark, font: font-sans, title),
  )
  v(0.5em)
  content
  v(10pt)
}

// [12] 例题框
#let example-box(content, cols: 1) = {
  block(
    width: 100%,
    breakable: true,
    fill: color-paper-bg,
    outset: (x: 1.5cm),
    stroke: none,
    inset: (y: 20pt, x: 5pt),
    [
      #text(fill: color-main, weight: "bold", size: 11pt, font: font-sans)[Sample Problem | 典型例题]
      #v(8pt)
      #let body-style = {
        set text(size: 9pt)
        set par(leading: 0.6em, justify: true)
        set enum(numbering: "1.A.", indent: 0.5em, body-indent: 0.5em)
        set enum(spacing: 0.8em)
        content
      }
      #if cols == 2 {
        columns(2, gutter: 0.8cm, body-style)
      } else {
        block(width: 100%, body-style)
      }
    ],
  )
  v(1cm)
}

// [12-B] 章末测验框
#let chapter-quiz(questions: none, answers: none, cols: 1) = {
  v(1cm)
  block(
    width: 100%,
    breakable: true,
    fill: color-light-gray.transparentize(60%),
    radius: 0pt,
    outset: (x: 1.5cm),
    inset: (y: 25pt),
    [
      #grid(
        columns: (auto, 1fr),
        gutter: 10pt,
        align: horizon,
        box(fill: color-dark, radius: 100pt, inset: (x: 12pt, y: 6pt), text(
          fill: white,
          weight: "bold",
          size: 10pt,
          font: font-sans,
        )[本章测验]),
        text(fill: color-dark, weight: "bold", size: 11pt, font: font-sans)[CHAPTER QUIZ | 考点查缺补漏],
      )
      #v(15pt)
      #let question-style(body) = {
        set text(size: 9pt, fill: color-text)
        set par(leading: 0.6em, justify: true)
        set enum(numbering: "1.A.", indent: 0.5em, body-indent: 0.5em)
        set enum(spacing: 1.2em)
        body
      }
      #if cols == 2 {
        columns(2, gutter: 1cm)[ #question-style(questions) ]
      } else {
        block(width: 100%)[ #question-style(questions) ]
      }
      #v(5pt)
      #pad(left: 5pt, bottom: 5pt, text(
        fill: color-main,
        size: 9pt,
        weight: "bold",
        font: font-sans,
      )[ 💡 参考答案 (Answer Key) ])
      #block(
        width: 100%,
        fill: white,
        stroke: (paint: color-text.lighten(70%), dash: "dashed", thickness: 1.5pt),
        radius: 4pt,
        inset: 15pt,
        [
          #let answer-style(body) = {
            set text(size: 9pt, fill: color-text)
            set par(leading: 0.6em, justify: true)
            set enum(
              numbering: n => box(fill: color-light-gray, inset: (x: 6pt, y: 2pt), radius: 3pt, text(
                weight: "bold",
                fill: color-dark,
                font: font-sans,
              )[#n]),
              body-indent: 0.8em,
            )
            body
          }
          #if cols == 2 {
            columns(2, gutter: 1cm)[ #answer-style(answers) ]
          } else {
            block(width: 100%)[ #answer-style(answers) ]
          }
        ],
      )
    ],
  )
  v(1cm)
}

// [13] 答案与解析框
#let solution-box(num: none, answer: "", rate: none, ref: none, content) = {
  block(
    width: 100%,
    fill: white,
    radius: 2pt,
    inset: 10pt,
    [
      #grid(
        columns: (auto, 1fr),
        gutter: 5pt,
        align: horizon,
        box({
          if num != none {
            box(fill: color-light-gray, inset: (x: 5pt, y: 1pt), radius: 3pt, text(
              size: 8pt,
              weight: "bold",
              fill: color-text,
              font: font-sans,
            )[#num])
            h(5pt)
          }
          text(fill: color-main, weight: "bold", size: 9pt, font: font-sans)[ANSWER: #answer]
        }),
        if rate != none {
          align(right, text(fill: color-text.lighten(50%), size: 8pt)[正确率: #rate])
        },
      )
      #v(3pt)
      #if ref != none {
        text(fill: color-text.lighten(40%), size: 8pt, style: "italic")[Ref: #ref]
        v(2pt)
      }
      #set text(size: 9pt, fill: color-text)
      #set par(leading: 0.6em, justify: true)
      #set enum(numbering: "①", body-indent: 0.2em)
      #set list(marker: "•", indent: 0.5em)
      #content
    ],
  )
  v(5pt)
}

// [14] 通用美化表格
#let styled-table(columns: auto, full: false, ..content) = {
  let table-width = if full { 100% + 5.8cm } else { 100% }
  block(
    width: table-width,
    stroke: (top: 1.3pt + color-main, bottom: 2.5pt + color-main),
    inset: 0pt,
    [
      #set text(size: 9pt)
      #show table.cell.where(y: 0): set text(fill: color-main, weight: "bold", font: font-sans)
      #table(
        columns: columns, inset: (y: 8pt, x: 8pt), align: horizon,
        stroke: (x, y) => (
          bottom: if y == 0 { 0.5pt + color-main } else { (thickness: 0.5pt, paint: color-gray-bar, dash: "dotted") },
        ),
        fill: (x, y) => if y == 0 { color-main.transparentize(95%) } else { white },
        ..content
      )
    ],
  )
}

// [15] 板块头
#let section-header(number: "A", title: "板块", subtitle: "", intro: none) = {
  block(below: 10pt, breakable: false)[
    #grid(
      columns: (auto, auto, 1fr),
      gutter: 12pt,
      align: horizon,
      text(fill: color-main, weight: "black", size: 42pt, font: font-sans)[#number],
      line(start: (0pt, 0pt), end: (0pt, 26pt), stroke: 2pt + color-main.transparentize(60%)),
      text(fill: color-dark, weight: "extrabold", size: 22pt, font: font-sans)[#title],
    )
    #stack(
      dir: ttb,
      spacing: 8pt,
      text(size: 10pt, weight: "bold", fill: color-main, font: font-sans)[#subtitle],
      line(length: 100%, stroke: 1.5pt + color-main),
      if intro != none {
        pad(top: 4pt, text(size: 9pt, style: "italic", fill: rgb("#888888"))[#intro #v(10pt)])
      },
    )
  ]
}

// [16] 考点列表
#let syllabus-body(content-data: (), number-prefix: "1") = {
  let c-accent = color-main
  let c-desc = rgb("#888888")
  let pt-counter = counter("syllabus-pt-" + number-prefix)
  pt-counter.update(0)

  let ref-tag(t) = text(size: 7.5pt, weight: "bold", fill: c-accent.lighten(30%), style: "italic")[Ref: #t]
  let num-badge(n) = box(fill: c-accent, radius: 2pt, width: 14pt, height: 14pt, align(center + horizon, text(
    fill: white,
    size: 9pt,
    weight: "bold",
    n,
  )))

  columns(2, gutter: 1cm)[
    #set par(leading: 0.5em, justify: true)
    #for block-item in content-data {
      block(below: 16pt, breakable: false)[
        #grid(
          columns: (auto, 1fr),
          gutter: 6pt,
          align: horizon,
          box(width: 6pt, height: 6pt, fill: c-accent.transparentize(40%), radius: 1pt),
          text(fill: c-accent, weight: "extrabold", size: 11pt, font: font-sans)[#block-item.name],
        )
        #v(-3pt)
        #pad(left: 12pt, line(length: 100%, stroke: 0.5pt + c-accent.transparentize(80%)))
      ]
      pad(left: 1.2em)[
        #for pt in block-item.points {
          pt-counter.step()
          block(breakable: false, below: 18pt)[
            #grid(
              columns: (14pt, 1fr, auto),
              gutter: 6pt,
              align: horizon,
              context num-badge(pt-counter.display()),
              text(weight: "bold", size: 10pt, fill: color-dark, font: font-sans)[#pt.topic],
              if pt.ref != "" { ref-tag(pt.ref) },
            )
            #if pt.desc != "" {
              v(5pt)
              pad(left: 20pt, text(size: 8.5pt, fill: c-desc, weight: "regular")[#pt.desc])
            }
          ]
        }
      ]
      v(4pt)
    }
  ]
}

// 4. 项目初始化函数
// ------------------------------------------
#let project(doc) = {
  // 页面设置
  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 1.5cm, right: 1.5cm),
    background: none,
  )

  // 文本基础设置
  set text(
    font: font-serif,
    lang: "zh",
    region: "cn",
    size: 10pt,
    fill: color-text,
  )

  // [0] 全局强调样式重写 (加粗 -> 楷体 + 伪粗体)
  show strong: it => {
    text(font: font-kaiti, weight: "bold", it.body)
  }

  // [1] 标准标题样式映射 (4-Level Hierarchy)
  // Chapter: Custom #大标题 function (not a heading)
  // L1 (=): Section separator
  // L2 (==): Topic (考点) - populates Syllabus
  // L3 (===): Subtopic (小标题)

  // Counter for Topics (resets per Section)
  let topic-num = counter("topic-heading")
  // Counter for Subtopics (resets per Topic)
  let subtopic-num = counter("subtopic-heading")

  show heading.where(level: 1): it => {
    // Level 1: Section (节)
    topic-num.update(0) // Reset topic counter
    v(1em)
    separator(it.body)
    v(0.5em)
  }

  show heading.where(level: 2): it => {
    // Level 2: Topic (考点)
    topic-num.step()
    subtopic-num.update(0) // Reset subtopic counter
    v(0.8em)
    grid(
      columns: (auto, 1fr),
      gutter: 10pt,
      align: horizon,
      box(fill: color-main, width: 24pt, height: 24pt, radius: 2pt, align(center + horizon, text(
        fill: white,
        weight: "bold",
        size: 14pt,
        font: font-sans,
        context topic-num.display(),
      ))),
      text(size: 16pt, weight: "bold", fill: color-dark, font: font-sans, it.body),
    )
    v(0.5em)
  }

  show heading.where(level: 3): it => {
    // Level 3: Subtopic (小标题)
    subtopic-num.step()
    v(0.5em)
    text(fill: color-main, size: 14pt, weight: "extrabold", font: font-sans, context subtopic-num.display())
    h(0.5em)
    text(fill: color-dark, size: 12pt, weight: "bold", font: font-sans, it.body)
    v(0.3em)
  }

  // Set numbering (for outline/TOC purposes, not visual display)
  set heading(numbering: none)

  // 原文档内容
  doc
}
// ==========================================
// 5. 中文别名 + 自动编号 (Simple API)
// ==========================================

// 1. 自动计数器
#let topic-counter = counter("topic-counter")
#let example-counter = counter("example-counter")

// 重置计数器的辅助函数 (每章开始时调用)
#let reset-counters() = {
  topic-counter.update(0)
  example-counter.update(0)
}

// 2. 核心考点 (自动编号版)
// title: 考点标题 (字符串)
// body: 考点内容 ([...])
#let 考点(title, body) = {
  topic-counter.step()
  context topic-block(topic-counter.display(), title, body)
}

// 3. 内容分块 (简化版)
// 将 note 参数提名为第二个位置参数，方便书写
// body: 正文内容
// note: 侧边栏内容 (可选，默认为 none)
#let 正文(body, note: none) = {
  segment(body, note: note)
}

// 4. 侧边栏笔记 (中文别名)
// title: 笔记标题
// content: 笔记内容
#let 笔记(title, content, style: "blue") = sidenote(title, content, style: style)
#let 提示(title, content, style: "sticky") = sidenote(title, content, style: style)
#let 警告(title, content, style: "red") = sidenote(title, content, style: style)
#let 概念(title, content, style: "green") = sidenote(title, content, style: style)
#let 引用(title, content, style: "gray") = sidenote(title, content, style: style)

// 5. 页面元素别名
#let 重点(text) = mark(text)
#let 术语(text) = term(text)
#let 标签(text) = badge(text)
#let 小标题(num, text) = sub-section(num, text)

// 6. 容器组件
#let 信息(content) = info-box(content)
#let 引入(title, body) = intro-box(title, body)
#let 分节(text) = separator(text)

// 7. 特殊组件
#let 例题(content, cols: 1) = {
  example-box(content, cols: cols)
}

#let 表格(..args) = styled-table(..args)

#let 解析(num: none, answer: "", rate: none, ref: none, content) = {
  solution-box(num: num, answer: answer, rate: rate, ref: ref, content)
}

#let 测验(questions: none, answers: none, cols: 1) = {
  chapter-quiz(questions: questions, answers: answers, cols: cols)
}

#let 考点大纲(content-data: (), number-prefix: "1") = {
  syllabus-body(content-data: content-data, number-prefix: number-prefix)
}

// 8. 章节标题
#let 大标题(num, text) = {
  reset-counters()
  header-banner(num, text)
}

// 9. 板块标题 (Part A, B, C)
#let 板块(num, title, subtitle: "", intro: none) = {
  section-header(number: num, title: title, subtitle: subtitle, intro: intro)
}

// 10. 自动化 Syllabus 相关
// ------------------------------------------

// 用于在 Heading 中嵌入元数据
#let meta(ref: "", desc: "") = {
  metadata((type: "syllabus-topic", ref: ref, desc: desc))
}

// 用于在 分节 中嵌入元数据
#let section-meta(title) = {
  metadata((type: "syllabus-section", title: title))
}

// 重写 分节 以包含元数据
#let 分节(text) = {
  section-meta(text)
  separator(text)
}

// 自动生成 Syllabus
#let syllabus-auto(number-prefix: "1") = {
  let c-accent = color-main
  let c-desc = rgb("#888888")

  let ref-tag(t) = text(size: 7.5pt, weight: "bold", fill: c-accent.lighten(30%), style: "italic")[Ref: #t]
  let num-badge(n) = box(fill: c-accent, radius: 2pt, width: 14pt, height: 14pt, align(center + horizon, text(
    fill: white,
    size: 9pt,
    weight: "bold",
    str(n),
  )))

  // 获取所有 Section (L1) 和 Topic (L2) 和 Topic Metadata
  context {
    let all-meta = query(metadata)
    let sections = query(heading.where(level: 1)) // L1 Sections
    let topic-metas = all-meta.filter(m => m.value.at("type", default: "") == "syllabus-topic")
    let topics = query(heading.where(level: 2)) // L2 Topics

    // 混合排序：Topic Metadata 应紧跟在 Topic Heading 之后
    let all-elements = (sections + topics + topic-metas).sorted(key: it => (
      it.location().page(),
      it.location().position().y,
    ))

    // Local counter for topic numbering
    let topic-count = 0

    columns(2, gutter: 1cm)[
      #set par(leading: 0.5em, justify: true)

      #for (i, elem) in all-elements.enumerate() {
        if elem.func() == metadata {
          // --- Metadata Elements ---
          // Only "syllabus-topic" metadata is expected here
          // Skip it as it's handled by look-ahead in the Heading branch.
        } else if elem.func() == heading {
          let lvl = elem.depth

          if lvl == 1 {
            // --- Section (L1) Heading ---
            let sec-title = elem.body

            block(below: 16pt, breakable: false)[
              #grid(
                columns: (auto, 1fr),
                gutter: 6pt,
                align: horizon,
                box(width: 6pt, height: 6pt, fill: c-accent.transparentize(40%), radius: 1pt),
                text(fill: c-accent, weight: "extrabold", size: 11pt, font: font-sans)[#sec-title],
              )
              #v(-3pt)
              #pad(left: 12pt, line(length: 100%, stroke: 0.5pt + c-accent.transparentize(80%)))
            ]
          } else if lvl == 2 {
            // --- Topic (L2) Heading ---
            topic-count = topic-count + 1

            // Look ahead for Metadata
            let my-meta = (ref: "", desc: "")
            if i + 1 < all-elements.len() {
              let next-elem = all-elements.at(i + 1)
              // Ensure it is metadata and correct type
              if next-elem.func() == metadata and next-elem.value.at("type", default: "") == "syllabus-topic" {
                my-meta = next-elem.value
              }
            }

            let title-text = elem.body

            pad(left: 1.2em)[
              #block(breakable: false, below: 18pt)[
                #grid(
                  columns: (14pt, 1fr, auto),
                  gutter: 6pt,
                  align: horizon,
                  num-badge(topic-count),
                  text(weight: "bold", size: 10pt, fill: color-dark, font: font-sans, title-text),
                  if my-meta.ref != "" { ref-tag(my-meta.ref) },
                )
                #if my-meta.desc != "" {
                  v(5pt)
                  pad(left: 20pt, text(size: 8.5pt, fill: c-desc, weight: "regular")[#my-meta.desc])
                }
              ]
            ]
          }
        }
      }
    ]
  }
}
