# Mini Set & Model Theory（迷你集合论与模型论）

一套**从零开始、零依赖的 Lean 4 实现**，涵盖大学层次的集合论、模型论与数理逻辑。每个子包对应 MIT（及其他顶尖大学）课程，使用 Lean 4 证明助手从第一性原理构建形式化集合论与模型论基础。

## 子包

| 子包 | 主题 | 核心课程 |
|------|------|----------|
| [mini-set-core](mini-set-core/) | 集合论、隶属关系、运算、有限集 | MIT 18.510, Princeton MAT 560 |
| [mini-function-relation](mini-function-relation/) | 结构、同态、嵌入 | MIT 18.515, Berkeley Math 225B |
| [mini-language-structure](mini-language-structure/) | 形式语言、签名、结构 | MIT 18.510, Stanford Math 160 |
| [mini-satisfaction-model](mini-satisfaction-model/) | Tarski 语义、满足关系、初等等价 | MIT 18.515, Berkeley Math 229A |
| [mini-zfc-lite](mini-zfc-lite/) | ZFC 公理、序数/基数构造 | MIT 18.510, Princeton MAT 560 |
| [mini-compactness-completeness-lite](mini-compactness-completeness-lite/) | 紧致性定理、完备性定理、超积 | MIT 18.515, Oxford Part C |
| [mini-order-equivalence](mini-order-equivalence/) | 偏序、等价关系、序型 | MIT 18.510, Cambridge Part III |
| [mini-cardinal-ordinal](mini-cardinal-ordinal/) | 基数算术、序数算术、超限归纳 | MIT 18.510, Berkeley Math 225A |

## 设计理念

- **零外部依赖** -- 纯 Lean 4，仅导入内核模块
- **自包含子包** -- 每个子包拥有独立的 `lakefile.lean`、Core/、Morphisms/、Constructions/、Properties/、Theorems/
- **理论到代码的映射** -- 每个模块包含内联 `#eval` 示例和定理陈述
- **经典逻辑基础** -- 使用内核的经典自然演绎；关键结论（紧致性）需排中律

## 构建

每个子包独立构建。使用 Lake 构建：

```bash
cd mini-set-core
lake build
lake env lean --run Test/Smoke.lean
```

需要 **Lean 4** 和 **Lake**。

## 项目结构

```
1. mini-set-model-theory/
├── mini-set-core/                       # 集合论、隶属关系、有限集
├── mini-function-relation/              # 同态、嵌入
├── mini-language-structure/             # 形式语言、签名、结构
├── mini-satisfaction-model/             # Tarski 语义、初等等价
├── mini-zfc-lite/                       # ZFC 公理、序数/基数构造
├── mini-compactness-completeness-lite/  # 紧致性、完备性、超积
├── mini-order-equivalence/              # 偏序、等价关系
├── mini-cardinal-ordinal/               # 基数/序数算术、超限归纳
└── lakefile.lean
```

## 许可证

MIT
