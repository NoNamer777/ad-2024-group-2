import { readFile, writeFile } from 'fs/promises';

const tableName = 'Retailer_Site';

/**
 * @param {string} line
 * @param {string[]} parts
 */
function splitCsvLine(line, parts) {
    if (line.length === 0) return parts;

    if (line.charAt(0) === '"') {
        parts = [...parts, line.substring(1, line.indexOf('",'))];
        line = line.substring(line.indexOf('",') + 2);
    } else {
        const hasNextPart = line.indexOf(',') >= 0;
        parts = [...parts, line.substring(0, hasNextPart ? line.indexOf(',') : undefined)];
        line = hasNextPart ? line.substring(line.indexOf(',') + 1) : '';
    }
    return splitCsvLine(line, parts);
}

/** @param {string} line */
function formatLine(line) {
    const parts = splitCsvLine(line, []);
    let formattedParts = [];

    for (const part of parts) {
        if (Number.isNaN(Number(part))) {
            formattedParts = [...formattedParts, `'${part.replace(`'`, `''`).replaceAll('"', '')}'`];
        } else if (part.length === 0) {
            formattedParts = [...formattedParts, 'NULL'];
        } else {
            formattedParts = [...formattedParts, part];
        }
    }
    return formattedParts.join(', ');
}

async function main() {
    let scriptContents = `INSERT INTO \`${tableName}\``;

    /** @type {string[]} */
    let columns;

    const csvContents = await readFile(`assets/data/csv/${tableName.toUpperCase()}.csv`, { encoding: 'utf8' });
    const lines = csvContents.split('\n').filter(line => line.length > 0);

    for (let idx = 0; idx < lines.length; idx++) {
        const line = lines[idx];

        if (idx === 0) {
            columns = line.toLowerCase().split(',').map(column => `\`${column}\``);
            scriptContents += `(${columns.join(', ')}) VALUES\n`
            continue;
        }
        scriptContents += `\t(${formatLine(line)})`;

        scriptContents += idx === lines.length - 1 ? ';\n' : ',\n';
    }
    await writeFile(`assets/data/sql/insert_${tableName.toLowerCase()}_data.sql`, scriptContents);
}

await main();