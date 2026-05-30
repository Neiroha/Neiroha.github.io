/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  wikiSidebar: [
    {
      type: 'doc',
      id: 'intro',
      label: '项目总览',
    },
    {
      type: 'category',
      label: '快速入门',
      collapsed: false,
      items: [
        'guide/getting-started',
        'guide/install-release',
        'guide/source-build',
      ],
    },
    {
      type: 'category',
      label: '核心工作流',
      collapsed: false,
      items: [
        {
          type: 'category',
          label: '提供商配置',
          collapsed: false,
          items: [
            'workflow/providers',
            'workflow/providers/local-engines',
            'workflow/providers/gpt-sovits',
            'workflow/providers/voxcpm',
            'workflow/providers/cosyvoice',
            'workflow/providers/cloud-engines',
            'workflow/providers/mimo',
            'workflow/providers/gemini',
            'workflow/providers/azure',
          ],
        },
        'workflow/voice-bank',
        'workflow/quick-tts',
        'workflow/dialog-tts',
        'workflow/phase-tts',
        'workflow/novel-reader',
        'workflow/video-dub',
      ],
    },
    {
      type: 'category',
      label: '配置与运维',
      collapsed: false,
      items: [
        'operations/settings-tasks-storage',
        'operations/api-server',
        'operations/storage-troubleshooting',
        'operations/github-actions-builds',
      ],
    },
    {
      type: 'category',
      label: 'API 参考',
      collapsed: false,
      items: [
        'api-zh',
        'api',
      ],
    },
  ],
};

module.exports = sidebars;
