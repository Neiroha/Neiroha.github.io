const {themes: prismThemes} = require('prism-react-renderer');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Neiroha Wiki',
  tagline: 'AI 音频中间件与配音工作站',
  favicon: 'img/neiroha_logo.png',

  url: 'https://neiroha.github.io',
  baseUrl: '/',

  organizationName: 'Neiroha',
  projectName: 'Neiroha.github.io',

  trailingSlash: false,
  onBrokenLinks: 'warn',
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },

  i18n: {
    defaultLocale: 'zh-Hans',
    locales: ['zh-Hans'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/',
          sidebarPath: './sidebars.js',
          showLastUpdateTime: false,
          showLastUpdateAuthor: false,
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/screenshot_overview.png',
      metadata: [
        {
          name: 'description',
          content:
            'Neiroha 的使用手册、API 参考、开发计划与项目文档索引。',
        },
      ],
      navbar: {
        title: 'Neiroha Wiki',
        logo: {
          alt: 'Neiroha',
          src: 'img/neiroha_logo.png',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'wikiSidebar',
            position: 'left',
            label: '文档',
          },
          {to: '/api-zh', label: 'API', position: 'left'},
          {to: '/plan', label: '计划', position: 'left'},
          {
            href: 'https://github.com/Neiroha/Neiroha',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'light',
        links: [
          {
            title: 'Wiki',
            items: [
              {label: '项目总览', to: '/'},
              {label: '快速开始', to: '/guide/getting-started'},
              {label: 'API 参考', to: '/api-zh'},
            ],
          },
          {
            title: '项目',
            items: [
              {label: '开发计划', to: '/plan'},
              {label: '缺陷与风险', to: '/bugs'},
              {
                label: '源代码仓库',
                href: 'https://github.com/Neiroha/Neiroha',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Neiroha.`,
      },
      colorMode: {
        defaultMode: 'light',
        disableSwitch: false,
        respectPrefersColorScheme: true,
      },
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 4,
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
        additionalLanguages: ['bash', 'dart', 'json', 'yaml'],
      },
    }),
};

module.exports = config;
