#import "@preview/ctyp:0.3.2": ctyp

#let (ctypset, (song, hei, kai, fang)) = ctyp(
  fontset-cjk: "windows",
  font-latin: (serif: "Times New Roman"),
  fix-first-line-indent: false,
  heading-numbering: ((format: "一、", sep: 0em),),
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
  table(
    columns: (1.75fr, 3fr, 1fr, 2fr),
    stroke: 0.5pt,
    align: center,
    inset: 0.75em,
    [*年级、专业、班级*], student-class, [*姓名*], student-name,
  )
  table(
    columns: (1fr, 2fr, 1fr, 2.6fr),
    stroke: 0.5pt,
    align: center,
    inset: 0.75em,
    [*实验题目*], table.cell(colspan: 3, title),
    [*实验时间*], date, [*实验地点*], location,
    [*实验成绩*], grade, [*实验性质*], experiment-types,
  )
}

#let teacher-evaluation() = [
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
  set par(leading: 1em, spacing: 1.5em)
  show table: set block(below: 0pt)

  report-title(course)
  student-info(
    student-class,
    student-name,
    title,
    date,
    location,
    grade,
  )

  set par(spacing: 0.9em)
  set list(spacing: 0.5em)
  table(
    columns: 1fr,
    stroke: 0.5pt,
    inset: (x: 0.75em, y: 1em),
    teacher-evaluation(),
    ..sections.map(((section-title, body)) => report-section(section-title, body)),
  )
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
