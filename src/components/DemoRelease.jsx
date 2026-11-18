import React, {useEffect, useState} from 'react';

export default function DemoRelease({loading, unavailable, versionLabel, openLabel}) {
  const [release, setRelease] = useState(undefined);

  useEffect(() => {
    const controller = new AbortController();
    fetch('/demo/release.json', {signal: controller.signal})
      .then((response) => response.ok ? response.json() : null)
      .then(setRelease)
      .catch(() => {
        if (!controller.signal.aborted) setRelease(null);
      });
    return () => controller.abort();
  }, []);

  return (
    <div className="margin-bottom--lg" aria-live="polite">
      {release?.tag ? (
        <>
          <p>{versionLabel} <strong>{release.tag}</strong></p>
          <a className="button button--primary" href="/demo/">{openLabel}</a>
        </>
      ) : <p>{release === undefined ? loading : unavailable}</p>}
    </div>
  );
}
