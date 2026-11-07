#import "@preview/ctyp:0.3.2": ctyp

// 论文常用字体集：宋体正文、黑体标题/加粗、楷体强调、Maple Mono NF 代码
// 说明：raw（行内代码与代码块）统一使用 Maple Mono NF，
//       "Maple Mono NF" 字族在 Windows 上包含 MapleMono-NF-CN（含中文字形）。
#let paper-fontset = (
  family: (
    song: (name: "SimSun"),
    hei: (name: "SimHei"),
    kai: (name: "KaiTi"),
    fang: (name: "FangSong"),
    lishu: (name: "LiSu"),
    youyuan: (name: "YouYuan"),
    maple: (name: "Maple Mono NF"),
  ),
  map: (
    text: (cjk: "song", latin: "serif"),
    strong: (cjk: "hei", latin: "serif"),
    emph: (cjk: "kai", latin: "serif"),
    raw: (cjk: "maple", latin: "mono"),
    heading: (cjk: "hei", latin: "serif"),
    title: (cjk: "hei", latin: "serif"),
  ),
)

#let (ctypset, (song, hei, kai, fang)) = ctyp(
  fontset-cjk: paper-fontset,
  font-latin: (serif: "Times New Roman", mono: "Maple Mono NF"),
  fix-first-line-indent: false,
  // 各级标题编号：一、 /（一）/ 1.，与通用中文论文格式一致
  heading-numbering: (
    (format: "一、", sep: 0em),
    (format: (..nums) => numbering("（一）", nums.pos().last()), sep: 0em),
    (format: (..nums) => numbering("1.", nums.pos().last()), sep: 0.5em),
  ),
)

#let checkbox = text(font: "Segoe UI Symbol")[□]
#let checkbox-filled = text(font: "Segoe UI Symbol")[■]
#let checkbox-checked = text(font: "Segoe UI Symbol")[☑︎]
#let experiment-types = [
  #checkbox 验证性 #h(1em)
  #checkbox 设计性 #h(1em)
  #checkbox 综合性
]

#let report-title(course) = align(center)[
  #text(size: 16pt)[
    #hei(weight: "bold")[《#course》实验报告]
  ]
]

#let student-info(
  student-class,
  student-name,
  title,
  date,
  location,
  grade,
) = {
  // 只有最外层表格需要贴边：给表格套一层 below: 0pt 的块，
  // 让后续表格紧贴上来；不写全局 show table 规则，避免影响嵌套表格
  block(below: 0pt, table(
    columns: (1.75fr, 3fr, 1fr, 2fr),
    stroke: 0.5pt,
    align: center,
    inset: 0.75em,
    [*年级、专业、班级*], student-class, [*姓名*], student-name,
  ))
  block(below: 0pt, table(
    columns: (1fr, 2fr, 1fr, 2.6fr),
    stroke: 0.5pt,
    align: center,
    inset: 0.75em,
    [*实验题目*], table.cell(colspan: 3, title),
    [*实验时间*], date, [*实验地点*], location,
    [*实验成绩*], grade, [*实验性质*], experiment-types,
  ))
}

#let teacher-evaluation() = [
  // 表格式评语区不是正文段落，不适用首行缩进
  #set par(first-line-indent: 0em)

  #text(size: 12pt)[#hei[教师评价：]]

  #block(above: 1em, below: 1em)[
    #kai[
      #table(
        columns: (1fr, 1fr, 1fr),
        stroke: none,
        inset: (x: 0em, y: 1em),
        [#checkbox 算法/实验过程正确；], [#checkbox 源程序/实验内容提交], [#checkbox 程序结构/实验步骤合理；],
        [#checkbox 实验结果正确；], [#checkbox 语法、语义正确；], [#checkbox 报告规范；],
        [其他：],
      )
    ]
  ]

  #align(right)[评价教师签名： #h(12em)]
]

#let report-section(title, body) = [
  = #title

  #body
]

#let experiment-report(
  course: [],
  student-class: [],
  student-name: [],
  title: [],
  date: [],
  location: [],
  grade: [],
  sections: (),
) = {
  show: ctypset
  set text(size: 10.5pt)

  // 中国通用论文段落标准（以 em 计）：
  // - 行距 1.5 倍：宋体单倍行距约为 1.3 倍字号，1.5 倍即约 1.95em；
  //   Typst 的行框高度约 0.68em，故 leading = 1.95em - 0.68em ≈ 1.25em。
  // - 段前段后 0：Typst 中段落间距取与 leading 相同的值，才能与行距一致、
  //   保持统一行网格（若取 0em，段落会挤在一起，明显小于行距）。
  // - 首行缩进 2 字符 = 2em，两端对齐。
  let line-leading = 1.25em
  set par(
    leading: line-leading,
    spacing: line-leading,
    first-line-indent: (amount: 2em, all: true),
    justify: true,
  )

  // 标题：按通用论文格式“段前 0.5 行、段后 0 行”换算为标题字号的 em。
  // Typst 行框比字形小，直接取 0 会与正文重叠，故取 above: 1em、below: 0.65em，
  // 呈现“上留白、下紧凑”的标准效果。
  show heading: set block(above: 1em, below: 0.65em)

  // 无序列表、有序列表：行距与正文一致（1.5 倍），项目之间不额外留白，
  // 整体缩进 2 字符，与正文首行缩进对齐
  set list(spacing: line-leading, indent: 2em, body-indent: 0.5em)
  set enum(spacing: line-leading, indent: 2em, body-indent: 0.5em)

  // 表格贴边只作用于最外层表格（student-info 的两张表、下方内容表）：
  // 在表格外面套一个 below: 0pt 的块即可，不再使用全局 show table 规则，
  // 因此表格内部的嵌套表格（如教师评价的复选框表、正文中的数据表）保持默认间距。
  report-title(course)
  student-info(
    student-class,
    student-name,
    title,
    date,
    location,
    grade,
  )

  block(below: 0pt, table(
    columns: 1fr,
    stroke: 0.5pt,
    inset: (x: 0.75em, y: 1em),
    teacher-evaluation(),
    ..sections.map(((section-title, body)) => report-section(section-title, body)),
  ))
}

#experiment-report(
  course: [],
  student-class: [],
  student-name: [],
  title: [],
  date: [],
  location: [],
  grade: [],
  sections: (
    ([实验目的], []),
    ([实验项目内容], []),
    ([实验过程或算法（源程序）], []),
    ([实验结果及分析和（或）源程序调试过程], []),
  ),
)
